part of 'login_page_bloc.dart';

@immutable
sealed class LoginPageEvent {}

final class LoginSubmitted extends LoginPageEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}
