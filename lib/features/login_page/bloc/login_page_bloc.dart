import 'package:bloc/bloc.dart';
import 'package:credito_solitario_mobile/core/services/login_service.dart';
import 'package:meta/meta.dart';

part 'login_page_event.dart';
part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  final LoginService loginService;

  LoginPageBloc({required this.loginService}) : super(LoginPageInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginPageState> emit,
  ) async {
    emit(LoginPageLoading());

    try {
      final result = await loginService.login(event.email, event.password);

      if (result['success'] == true) {
        emit(LoginPageSuccess());
      } else {
        emit(LoginPageError(error: result['error'] ?? 'Error desconocido'));
      }
    } catch (e) {
      emit(LoginPageError(error: 'Error: ${e.toString()}'));
    }
  }
}
