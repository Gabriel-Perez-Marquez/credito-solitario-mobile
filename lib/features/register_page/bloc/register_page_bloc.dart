import 'package:bloc/bloc.dart';
import 'package:credito_solitario_mobile/core/services/register_service.dart';
import 'package:equatable/equatable.dart';

part 'register_page_event.dart';
part 'register_page_state.dart';

class RegisterPageBloc extends Bloc<RegisterPageEvent, RegisterPageState> {
  RegisterPageBloc(RegisterService registerService) : super(RegisterPageInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterPageLoading());
    try {
      await registerService.register(
        name: event.name,
        apellidos: event.apellidos,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        telefono: event.telefono,
        saldo: event.saldo,
        dni: event.dni,
        municipio: event.municipio,
        calle: event.calle,
        numCasa: event.numCasa,
        provincia: event.provincia,
      );
      emit(RegisterPageSuccess());
    } catch (e) {
      emit(RegisterPageError(error: e.toString().replaceAll('Exception: ', '')));
    }
    });
    
    
  }
}
