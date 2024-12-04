import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dev_test/login/verification/cubit/verification_cubit.dart';
import 'package:flutter_dev_test/shared/design_system/buttons/button_filled.dart';
import 'package:flutter_injections/flutter_injections.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../shared/theme/theme.dart';

class VerificationPageArguments {
  final String username;
  final String password;

  VerificationPageArguments({required this.username, required this.password});
}

class VerificationPage extends StatefulWidget {
  final VerificationPageArguments arguments;
  const VerificationPage({
    super.key,
    required this.arguments,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  VerificationCubit verificationCubit =
      FlutterInjections.get<VerificationCubit>();
  String otpCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocConsumer<VerificationCubit, VerificationState>(
        bloc: verificationCubit,
        listener: (context, state) {
          if (state is VerificationSuccess) {
            Navigator.pop(context, state.totpSecret);
          }
          if (state is VerificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Código inválido')),
            );
          }
        },
        builder: (context, state) {
          if (state is VerificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 08,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Verificação',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Insira o código que foi enviado:',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9496AA)),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 74,
                    bottom: 32,
                  ),
                  child: OtpTextField(
                    numberOfFields: 6,
                    fillColor: const Color(0XFFE7E7EF),
                    focusedBorderColor: const Color(0XFF7A5D3E),
                    fieldHeight: 52,
                    fieldWidth: 48,
                    margin: const EdgeInsets.only(right: 5),
                    showFieldAsBox: true,
                    onCodeChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          otpCode = '';
                        });
                      }
                    },
                    onSubmit: (String verificationCode) {
                      setState(() {
                        otpCode = verificationCode;
                      });
                    },
                  ),
                ),
                ButtonFilled(
                  label: 'Confirmar',
                  color: const Color(0xFF7A5D3E),
                  isEnabled: otpCode.length == 6,
                  onPressed: () async {
                    await verificationCubit.getRecoverySecret(
                      username: widget.arguments.username,
                      password: widget.arguments.password,
                      code: otpCode,
                    );
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: TextButton.icon(
                      onPressed: () {},
                      label: const Text(
                        'Não recebi o código',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      icon: Image.asset(Assets.messageQuestionIcon)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
