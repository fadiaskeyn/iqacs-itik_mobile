import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      // Simulasi autentikasi
      await Future.delayed(Duration(seconds: 2));
      if (email == 'admin@gmail.com' && password == 'admin123') {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure('Invalid email or password'));
      }
    } catch (e) {
      emit(LoginFailure('Something went wrong'));
    }
  }
}
