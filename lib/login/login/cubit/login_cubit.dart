import 'package:bloc/bloc.dart';
import 'package:flutter_dev_test/login/repository/login_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginRepository;
  LoginCubit({required this.loginRepository}) : super(const LoginInitial());

  Future<void> login(
      {required String username,
      required String password,
      String? totpSecret}) async {
    emit(const LoginLoading());
    final success = await loginRepository.login(
      username: username,
      password: password,
      totpSecret: totpSecret,
    );
    if (success) {
      emit(const LoginSuccess());
    } else {
      emit(const LoginError());
    }
  }
}
