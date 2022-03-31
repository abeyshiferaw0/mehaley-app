import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/api_response/save_user_data.dart';
import 'package:mehaley/data/models/app_firebase_user.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/data/models/enums/user_login_type.dart';
import 'package:mehaley/data/repositories/auth_repository.dart';
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
    if (event is ContinueWithAppleEvent) {
      yield AuthLoadingState(userLoginType: UserLoginType.APPLE);
      try {
        AppFireBaseUser? appFireBaseUser = await signInWithApple();
        if (appFireBaseUser != null) {
          this.add(SaveUserEvent(appFireBaseUser: appFireBaseUser));
        } else {
          yield AuthErrorState(error: 'appFireBaseUser apple is null');
        }
      } catch (e) {
        yield AuthErrorState(error: e.toString());
      }
    } else if (event is ContinueWithGoogleEvent) {
      yield AuthLoadingState(userLoginType: UserLoginType.GOOGLE);
      try {
        AppFireBaseUser? appFireBaseUser = await signInWithGoogle();
        if (appFireBaseUser != null) {
          this.add(SaveUserEvent(appFireBaseUser: appFireBaseUser));
        } else {
          yield AuthErrorState(error: 'appFireBaseUser google is null');
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
          yield AuthErrorState(error: 'appFireBaseUser facebook is null');
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
              error: 'Unable to authenticate\nCheck your pin');
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
      print("eventevent=>> ${event.error}");
      yield PhoneAuthErrorState(error: event.error);
    } else if (event is AuthErrorEvent) {
      yield AuthErrorState(error: event.error);
    } else if (event is SaveUserEvent) {
      try {
        await authRepository.turnAllNotificationOn();
        await OneSignal.shared.disablePush(false);
        SaveUserData saveUserData = await authRepository.saveUser(
          event.appFireBaseUser,
        );
        await authRepository.setOneSignalExternalId(saveUserData.appUser);
        yield AuthSuccessState(
          appUser: saveUserData.appUser,
        );
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
      await authRepository.logOut();
      yield AuthLoggedOutState();
    }
  }

  Future<AppFireBaseUser?> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final credential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    UserCredential firebaseUser =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (firebaseUser.user != null) {
      return getAppFirebaseUser(
        firebaseUser: firebaseUser,
        userLoginType: UserLoginType.APPLE,
      );
    } else {
      throw 'Auth bloc googleAuth user is null';
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
        return getAppFirebaseUser(
          firebaseUser: firebaseUser,
          userLoginType: UserLoginType.GOOGLE,
        );
      } else {
        throw 'Auth bloc googleAuth user is null';
      }
    } else {
      throw 'Auth bloc googleAuth is null';
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
        return getAppFirebaseUser(
          firebaseUser: firebaseUser,
          userLoginType: UserLoginType.FACEBOOK,
        );
      } else {
        return null;
        //throw 'Auth bloc googleAuth user is null';
      }
    } else {
      throw 'Auth bloc signInWithFacebook loginResult.accessToken is null';
    }
  }

  Future<AppFireBaseUser?> signInWithPhoneNumber(
      String countryCode, String phoneNumber, int? resendToken) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '$countryCode$phoneNumber',
      forceResendingToken: resendToken,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("verificationCompleted =>  called");
        UserCredential firebaseUser =
            await firebaseAuth.signInWithCredential(credential);
        AppFireBaseUser appFireBaseUser = getAppFirebaseUser(
          firebaseUser: firebaseUser,
          countryCode: countryCode,
          phoneNumber: phoneNumber,
          userLoginType: UserLoginType.PHONE_NUMBER,
        );

        ///SAVE USER
        this.add(SaveUserEvent(appFireBaseUser: appFireBaseUser));
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          this.add(PhoneAuthErrorEvent(
              error: 'Unable to send sms, chek your internet connection'));
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
      codeAutoRetrievalTimeout: (String verificationId) {
        this.add(
          PhoneAuthErrorEvent(
            error: 'Sms timed out, please try again',
          ),
        );
      },
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
    required UserLoginType userLoginType,
  }) {
    return AppFireBaseUser(
      userName: firebaseUser.user!.displayName,
      email: firebaseUser.user!.email,
      phoneNumberCountryCode: countryCode,
      phoneNumber:
          phoneNumber != null ? phoneNumber : firebaseUser.user!.phoneNumber,
      socialProfileImgUrl: firebaseUser.user!.photoURL,
      authLoginId: firebaseUser.user!.uid,
      loginType: userLoginType,
    );
  }

  Future<AppFireBaseUser?> verifyPinCode(
      String pinCode, String verificationId) async {
    AppFireBaseUser? fireBaseUser;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: pinCode,
    );

    // Sign the user in (or link) with the credential
    await firebaseAuth.signInWithCredential(credential).then((firebaseUser) {
      fireBaseUser = getAppFirebaseUser(
        firebaseUser: firebaseUser,
        userLoginType: UserLoginType.PHONE_NUMBER,
      );
    }).catchError((e) {
      fireBaseUser = null;
    });

    return fireBaseUser;
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

class AppCodeSent {}
