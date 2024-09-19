part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class VerificationEvent extends LoginEvent {
  final String email;
  final String password;

  VerificationEvent({required this.email, required this.password});
}
