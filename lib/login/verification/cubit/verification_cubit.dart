import 'package:bloc/bloc.dart';
import 'package:flutter_dev_test/login/repository/login_repository.dart';

part 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  final LoginRepository loginRepository;
  VerificationCubit({required this.loginRepository})
      : super(const VerificationInitial());

  Future<void> getRecoverySecret({
    required String username,
    required String password,
    required String code,
  }) async {
    emit(const VerificationLoading());
    final success = await loginRepository.getRecoverySecret(
      username: username,
      password: password,
      code: code,
    );
    if (success != null) {
      emit(VerificationSuccess(totpSecret: success));
    } else {
      emit(const VerificationError());
    }
  }
}
