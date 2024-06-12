part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  LoginEvent();
}

class RegisterEvent extends AuthEvent {
  RegisterEvent();
}

class SignOutEvent extends AuthEvent {
  SignOutEvent();
}

class EditProfileEvent extends AuthEvent {
  EditProfileEvent();
}
