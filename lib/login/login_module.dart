import 'package:flutter/material.dart';
import 'package:flutter_dev_test/login/login/cubit/login_cubit.dart';
import 'package:flutter_dev_test/login/login/login_page.dart';
import 'package:flutter_dev_test/login/repository/login_repository.dart';
import 'package:flutter_dev_test/login/verification/cubit/verification_cubit.dart';
import 'package:flutter_injections/flutter_injections.dart';

class LoginModule extends FlutterModule {
  const LoginModule({super.key});

  @override
  Widget get child => const LoginPage();

  @override
  List<Inject<Object>> get injections => [
        Inject<LoginRepository>((i) => LoginRepository()),
        Inject<LoginCubit>(
            (i) => LoginCubit(loginRepository: i.find<LoginRepository>())),
        Inject<VerificationCubit>((i) =>
            VerificationCubit(loginRepository: i.find<LoginRepository>())),
      ];
}
