// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dev_test/home/home_page.dart';
import 'package:flutter_dev_test/login/login/cubit/login_cubit.dart';
import 'package:flutter_dev_test/login/repository/login_repository.dart';
import 'package:flutter_dev_test/login/verification/verification_page.dart';
import 'package:flutter_dev_test/login/widgets/text_form_field.dart';
import 'package:flutter_dev_test/shared/design_system/buttons/button_filled.dart';
import 'package:flutter_injections/flutter_injections.dart';

import '../../shared/theme/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool get isButtonEnabled =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  final LoginRepository loginRepository = LoginRepository();
  String? totpSecret;
  LoginCubit loginCubit = FlutterInjections.get<LoginCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: BlocConsumer<LoginCubit, LoginState>(
            bloc: loginCubit,
            listener: (context, state) {
              if (state is LoginSuccess) {
                Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              }
              if (state is LoginError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Credenciais inválidas')),
                );
              }
            },
            builder: (context, state) {
              if (state is LoginLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 72,
                          bottom: 36,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 35,
                              right: 0,
                              left: 0,
                              child: Image.asset(
                                Assets.curveUp,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              top: 130,
                              right: 0,
                              left: 0,
                              child: Image.asset(
                                width: double.infinity,
                                Assets.curveDown,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 76),
                              child: Image.asset(Assets.loginImage),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            CustomTextFormField(
                              label: 'E-mail',
                              controller: emailController,
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              label: 'Senha',
                              controller: passwordController,
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                            const SizedBox(height: 20),
                            ButtonFilled(
                                label: 'Entrar',
                                color: const Color(0xFF7A5D3E),
                                isEnabled: isButtonEnabled,
                                onPressed: () async {
                                  if (totpSecret == null) {
                                    await Navigator.push<String>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VerificationPage(
                                          arguments: VerificationPageArguments(
                                            username: emailController.text,
                                            password: passwordController.text,
                                          ),
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          totpSecret = value;
                                        });
                                      }
                                    });
                                  } else {
                                    loginCubit.login(
                                      username: emailController.text,
                                      password: passwordController.text,
                                      totpSecret: totpSecret,
                                    );
                                  }
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 36,
                    ),
                    child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Esqueci a senha',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7A5D3E),
                          ),
                        )),
                  ),
                ],
              );
            },
          )),
    );
  }
}
