part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLoadingState extends AuthState {
  final UserLoginType userLoginType;

  AuthLoadingState({required this.userLoginType});

  @override
  List<Object?> get props => [userLoginType];
}

class PhoneAuthLoadingState extends AuthState {
  final UserLoginType userLoginType;

  PhoneAuthLoadingState({required this.userLoginType});

  @override
  List<Object?> get props => [userLoginType];
}

class AuthSuccessState extends AuthState {
  final AppUser appUser;

  AuthSuccessState({required this.appUser});

  @override
  List<Object?> get props => [appUser];
}

class AuthErrorState extends AuthState {
  final String error;
  final String? pinCode;

  AuthErrorState({this.pinCode, required this.error});
  @override
  List<Object?> get props => [error, pinCode];
}

class PhoneAuthErrorState extends AuthState {
  final String error;

  PhoneAuthErrorState({required this.error});
  @override
  List<Object?> get props => [error];
}

class PhoneAuthCodeSentState extends AuthState {
  final String verificationId;
  final int? resendToken;

  PhoneAuthCodeSentState({required this.verificationId, this.resendToken});
  @override
  List<Object?> get props => [verificationId, resendToken];
}

class LastSmsStillActiveState extends AuthState {
  @override
  List<Object?> get props => [];
}

class ResendCodeState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthDumState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthUpdateSuccessState extends AuthState {
  final AppUser appUser;

  AuthUpdateSuccessState({required this.appUser});

  @override
  List<Object?> get props => [appUser];
}

class AuthProfileUpdatingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLoggedOutState extends AuthState {
  @override
  List<Object?> get props => [];
}
