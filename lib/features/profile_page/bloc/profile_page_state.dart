part of 'profile_page_bloc.dart';

sealed class ProfilePageState extends Equatable {
  const ProfilePageState();

  @override
  List<Object> get props => [];
}

final class ProfilePageInitial extends ProfilePageState {}

final class ProfilePageLoading extends ProfilePageState {}

final class ProfilePageSuccess extends ProfilePageState {
  final Map<String, dynamic> profile;

  const ProfilePageSuccess({required this.profile});

  @override
  List<Object> get props => [profile];
}

final class ProfilePageError extends ProfilePageState {
  final String message;

  const ProfilePageError({required this.message});

  @override
  List<Object> get props => [message];
}
