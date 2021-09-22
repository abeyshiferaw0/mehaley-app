part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {}

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

  VerifyPhoneEvent(
      {required this.pinCode, required this.verificationId, this.resendToken});
  @override
  List<Object?> get props => [pinCode, verificationId, resendToken];
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
