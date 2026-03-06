part of 'register_page_bloc.dart';

sealed class RegisterPageState extends Equatable {
  const RegisterPageState();
  
  @override
  List<Object> get props => [];
}

final class RegisterPageInitial extends RegisterPageState {}
final class RegisterPageLoading extends RegisterPageState {}
final class RegisterPageSuccess extends RegisterPageState {}
final class RegisterPageError extends RegisterPageState {
  final String error;
  RegisterPageError({required this.error});
}