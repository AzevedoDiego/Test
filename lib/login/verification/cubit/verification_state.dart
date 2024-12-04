part of 'verification_cubit.dart';

sealed class VerificationState {
  const VerificationState();
}

final class VerificationInitial extends VerificationState {
  const VerificationInitial();
}

final class VerificationLoading extends VerificationState {
  const VerificationLoading();
}

final class VerificationSuccess extends VerificationState {
  final String totpSecret;
  const VerificationSuccess({required this.totpSecret});
}

final class VerificationError extends VerificationState {
  const VerificationError();
}
