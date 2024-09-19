import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:msap/services/authentication_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<VerificationEvent>(_onVerificationEvent);
  }

  void _onVerificationEvent(
      VerificationEvent event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoading());

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('assessment', 'Manual');

      final AuthenticationService service = AuthenticationService();
      await service.login();
      await prefs.setBool('login', true);

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
