import 'package:bloc/bloc.dart';
import 'package:credito_solitario_mobile/core/services/profile_service.dart';
import 'package:equatable/equatable.dart';

part 'profile_page_event.dart';
part 'profile_page_state.dart';

class ProfilePageBloc extends Bloc<ProfilePageEvent, ProfilePageState> {
  final ProfileService profileService;

  ProfilePageBloc(this.profileService) : super(ProfilePageInitial()) {
    on<ProfilePageGetProfile>((event, emit) async {
      emit(ProfilePageLoading());

      try {
        final apiProfile = await profileService.getMyProfile();
        emit(ProfilePageSuccess(profile: apiProfile));
      } catch (e) {
        emit(ProfilePageError(message: e.toString()));
      }
    });
  }
}
