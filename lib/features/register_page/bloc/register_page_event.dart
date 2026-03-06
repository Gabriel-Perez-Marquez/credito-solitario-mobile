part of 'register_page_bloc.dart';

sealed class RegisterPageEvent extends Equatable {
  const RegisterPageEvent();

  @override
  List<Object> get props => [];
}



final class RegisterSubmitted extends RegisterPageEvent {
  final String name;
  final String apellidos;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String telefono;
  final int saldo;
  final String dni;
  final String municipio;
  final String calle;
  final String numCasa;
  final String provincia;

  const RegisterSubmitted({
    required this.name,
    required this.apellidos,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.telefono,
    required this.saldo,
    required this.dni,
    required this.municipio,
    required this.calle,
    required this.numCasa,
    required this.provincia,
  });

}