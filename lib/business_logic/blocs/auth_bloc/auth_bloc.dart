import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/app_firebase_user.dart';
import 'package:elf_play/data/models/app_user.dart';
import 'package:elf_play/data/models/enums/user_login_type.dart';
import 'package:elf_play/data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.authRepository,
    required this.firebaseAuth,
  }) : super(AuthInitial()) {
    listenToFirebaseAuthChanges();
  }

  final FirebaseAuth firebaseAuth;
  final AuthRepository authRepository;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is ContinueWithGoogleEvent) {
      yield AuthLoadingState(userLoginType: UserLoginType.GOOGLE);
      try {
        AppFireBaseUser? appFireBaseUser = await signInWithGoogle();
        if (appFireBaseUser != null) {
          this.add(SaveUserEvent(appFireBaseUser: appFireBaseUser));
        } else {
          yield AuthErrorState(error: "appFireBaseUser is null");
        }
      } catch (e) {
        yield AuthErrorState(error: e.toString());
      }
    } else if (event is ContinueWithFacebookEvent) {
      yield AuthLoadingState(userLoginType: UserLoginType.FACEBOOK);
      try {
        AppFireBaseUser? appFireBaseUser = await signInWithFacebook();
        if (appFireBaseUser != null) {
          this.add(SaveUserEvent(appFireBaseUser: appFireBaseUser));
        } else {
          yield AuthErrorState(error: "appFireBaseUser is null");
        }
      } catch (e) {
        yield AuthErrorState(error: e.toString());
      }
    } else if (event is ContinueWithPhoneEvent) {
      yield PhoneAuthLoadingState(userLoginType: UserLoginType.PHONE_NUMBER);
      try {
        await signInWithPhoneNumber(event.countryCode, event.phoneNumber, null);
      } catch (e) {
        yield AuthErrorState(error: e.toString());
      }
    } else if (event is VerifyPhoneEvent) {
      yield PhoneAuthLoadingState(userLoginType: UserLoginType.PHONE_NUMBER);
      try {
        AppFireBaseUser? appFireBaseUser =
            await verifyPinCode(event.pinCode, event.verificationId);

        if (appFireBaseUser != null) {
          this.add(SaveUserEvent(appFireBaseUser: appFireBaseUser));
        } else {
          yield PhoneAuthErrorState(
              error: "Unable to authenticate\nCheck your pin");
        }
      } catch (e) {
        yield AuthErrorState(error: e.toString());
      }
    } else if (event is ResendPinCodeEvent) {
      yield PhoneAuthLoadingState(userLoginType: UserLoginType.PHONE_NUMBER);
      //CHECK LAST TIME SENT SMS RESEND IF LAST IS BEFORE MORE THAT A MINUTE

      int nowTime = DateTime.now().millisecondsSinceEpoch;
      int lastTime = AppHiveBoxes.instance.userBox.get(
        AppValues.lastPhoneVerificationSentTimeKey,
        defaultValue: {
          DateTime.now().subtract(Duration(hours: 1)).millisecondsSinceEpoch
        },
      );

      if ((nowTime - lastTime) > 30000) {
        yield ResendCodeState();
      } else {
        yield LastSmsStillActiveState();
      }
    } else if (event is PhoneAuthCodeSentEvent) {
      yield PhoneAuthCodeSentState(
        verificationId: event.verificationId,
        resendToken: event.resendToken,
      );
    } else if (event is AuthSuccessEvent) {
      this.add(SaveUserEvent(appFireBaseUser: event.appFireBaseUser));
    } else if (event is PhoneAuthErrorEvent) {
      yield PhoneAuthErrorState(error: event.error);
    } else if (event is AuthErrorEvent) {
      yield AuthErrorState(error: event.error);
    } else if (event is SaveUserEvent) {
      try {
        await authRepository.setOneSignalExternalId(event.appFireBaseUser);
        OneSignal.shared.disablePush(false);
        await authRepository.saveUser(event.appFireBaseUser);
        yield AuthSuccessState();
      } catch (error) {
        yield AuthErrorState(error: error.toString());
      }
    } else if (event is EditUserEvent) {
      yield AuthProfileUpdatingState();
      try {
        final AppUser appUser = await authRepository.updateUser(
          event.userName,
          event.image,
          event.imageChanged,
        );
        yield AuthUpdateSuccessState(appUser: appUser);
      } catch (error) {
        yield AuthErrorState(error: error.toString());
      }
    } else if (event is LogOutEvent) {
      authRepository.logOut();
      yield AuthLoggedOutState();
    }
  }

  Future<AppFireBaseUser?> signInWithGoogle() async {
    // Trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential

      UserCredential firebaseUser =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (firebaseUser.user != null) {
        return getAppFirebaseUser(firebaseUser: firebaseUser);
      } else {
        throw "Auth bloc googleAuth user is null";
      }
    } else {
      throw "Auth bloc googleAuth is null";
    }
  }

  Future<AppFireBaseUser?> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    if (loginResult.accessToken != null) {
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(
        loginResult.accessToken!.token,
      );

      // Once signed in, return the UserCredential
      UserCredential firebaseUser = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      if (firebaseUser.user != null) {
        return getAppFirebaseUser(firebaseUser: firebaseUser);
      } else {
        return null;
        //throw "Auth bloc googleAuth user is null";
      }
    } else {
      throw "Auth bloc signInWithFacebook loginResult.accessToken is null";
    }
  }

  Future<AppFireBaseUser?> signInWithPhoneNumber(
      String countryCode, String phoneNumber, int? resendToken) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "$countryCode$phoneNumber",
      forceResendingToken: resendToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential firebaseUser =
            await firebaseAuth.signInWithCredential(credential);

        AppFireBaseUser appFireBaseUser = getAppFirebaseUser(
          firebaseUser: firebaseUser,
          countryCode: countryCode,
          phoneNumber: phoneNumber,
        );

        ///SAVE USER
        this.add(SaveUserEvent(appFireBaseUser: appFireBaseUser));
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          this.add(PhoneAuthErrorEvent(
              error: "Unable to send sms, chek your internet connection"));
        } else {
          this.add(AuthErrorEvent(error: e.code));
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        //SAVE TIME OF CODE SENT
        AppHiveBoxes.instance.userBox.put(
          AppValues.lastPhoneVerificationSentTimeKey,
          DateTime.now().millisecondsSinceEpoch,
        );
        //HANDLE CODE SENT TO DEVICE
        this.add(
          PhoneAuthCodeSentEvent(
            verificationId: verificationId,
            resendToken: resendToken,
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void listenToFirebaseAuthChanges() {
    firebaseAuth.userChanges().listen((User? user) {
      if (user == null) {
        print('FIREBASE =>>> User is currently signed out');
      } else {
        print('FIREBASE =>>> User is signed in');
      }
    });
  }

  AppFireBaseUser getAppFirebaseUser({
    required UserCredential firebaseUser,
    String? countryCode,
    String? phoneNumber,
  }) {
    return AppFireBaseUser(
      userName: firebaseUser.user!.displayName,
      email: firebaseUser.user!.email,
      phoneNumberCountryCode: countryCode,
      phoneNumber:
          phoneNumber != null ? phoneNumber : firebaseUser.user!.phoneNumber,
      socialProfileImgUrl: firebaseUser.user!.photoURL,
      authLoginId: firebaseUser.user!.uid,
      loginType: UserLoginType.GOOGLE,
    );
  }

  Future<AppFireBaseUser?> verifyPinCode(
      String pinCode, String verificationId) async {
    AppFireBaseUser? fireBaseUser;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: pinCode);

    // Sign the user in (or link) with the credential
    await firebaseAuth.signInWithCredential(credential).then((firebaseUser) {
      fireBaseUser = getAppFirebaseUser(firebaseUser: firebaseUser);
    }).catchError((e) {
      fireBaseUser = null;
    });

    return fireBaseUser;
  }
}

class AppCodeSent {}
