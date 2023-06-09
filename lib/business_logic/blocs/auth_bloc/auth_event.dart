part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {}

class ContinueWithAppleEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class ContinueWithGoogleEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class ContinueWithFacebookEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class ContinueWithPhoneEvent extends AuthEvent {
  final String countryCode;
  final String phoneNumber;

  ContinueWithPhoneEvent({
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object?> get props => [phoneNumber];
}

class PhoneAuthCodeSentEvent extends AuthEvent {
  final String verificationId;
  final int? resendToken;

  PhoneAuthCodeSentEvent({required this.verificationId, this.resendToken});
  @override
  List<Object?> get props => [verificationId, resendToken];
}

class AuthSuccessEvent extends AuthEvent {
  final AppFireBaseUser appFireBaseUser;

  AuthSuccessEvent({required this.appFireBaseUser});
  @override
  List<Object?> get props => [appFireBaseUser];
}

class AuthErrorEvent extends AuthEvent {
  final String error;

  AuthErrorEvent({required this.error});
  @override
  List<Object?> get props => [error];
}

class PhoneAuthErrorEvent extends AuthEvent {
  final String error;

  PhoneAuthErrorEvent({required this.error});
  @override
  List<Object?> get props => [error];
}

class VerifyPhoneEvent extends AuthEvent {
  final String pinCode;
  final String verificationId;
  final int? resendToken;
  final bool? isForEthioTelePaymentAuth;

  VerifyPhoneEvent({
    required this.pinCode,
    required this.verificationId,
    this.resendToken,
    this.isForEthioTelePaymentAuth,
  });
  @override
  List<Object?> get props => [
        pinCode,
        verificationId,
        resendToken,
        isForEthioTelePaymentAuth,
      ];
}

class ResendPinCodeEvent extends AuthEvent {
  final int? resendToken;
  final String phoneNumber;

  ResendPinCodeEvent({required this.phoneNumber, this.resendToken});
  @override
  List<Object?> get props => [resendToken];
}

class SaveUserEvent extends AuthEvent {
  final AppFireBaseUser appFireBaseUser;

  SaveUserEvent({
    required this.appFireBaseUser,
  });
  @override
  List<Object?> get props => [appFireBaseUser];
}

class ValidateUserPhoneEvent extends AuthEvent {
  final AppFireBaseUser appFireBaseUser;

  ValidateUserPhoneEvent({
    required this.appFireBaseUser,
  });
  @override
  List<Object?> get props => [appFireBaseUser];
}

class EditUserEvent extends AuthEvent {
  final String userName;
  final File image;
  final bool imageChanged;

  EditUserEvent({
    required this.userName,
    required this.image,
    required this.imageChanged,
  });

  @override
  List<Object?> get props => [
        userName,
        image,
        imageChanged,
      ];
}

class LogOutEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}
