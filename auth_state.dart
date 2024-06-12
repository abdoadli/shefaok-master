part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class RegisterSuccess extends AuthState {
  final String? successMSG;

  RegisterSuccess(this.successMSG);
}

class RegisterLoading extends AuthState {}

class RegisterFailure extends AuthState {
  String? errorMsg;

  RegisterFailure({required errorMsg});
}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginFailure extends AuthState {
  final String errorMsg;

  LoginFailure({required this.errorMsg});

  
}

class SignOutLoading extends AuthState {}

class SignOutSuccess extends AuthState {}

class SignOutFailure extends AuthState {
  String? errorMsg;

  SignOutFailure({required errorMsg});
}

class EditProfileLoading extends AuthState {}

class EditProfileSuccess extends AuthState {
  final String? msg;

  EditProfileSuccess({required this.msg});
}

class EditProfileFailure extends AuthState {
  String? errorMsg;

  EditProfileFailure({required errorMsg});
}
