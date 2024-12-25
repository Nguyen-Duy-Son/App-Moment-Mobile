part of 'forgot_password_cubit.dart';

@immutable
class ForgotPasswordState extends Equatable {
  final String? email;
  final String? password;
  final LoadStatus? sendVerifyEmailStatus;
  final String? msgSendVerifyEmail;
  @override
  const ForgotPasswordState({
    this.email = "",
    this.password = "",
    this.sendVerifyEmailStatus = LoadStatus.INITIAL,
    this.msgSendVerifyEmail = "",
  });
  // copywith
  ForgotPasswordState copyWith({
    String? email,
    String? password,
    LoadStatus? sendVerifyEmailStatus,
    String? msgSendVerifyEmail,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      password: password ?? this.password,
      sendVerifyEmailStatus: sendVerifyEmailStatus ?? this.sendVerifyEmailStatus,
      msgSendVerifyEmail: msgSendVerifyEmail ?? this.msgSendVerifyEmail,
    );
  }

  @override
  List<Object?> get props => [
    email,
    sendVerifyEmailStatus,
    msgSendVerifyEmail,
    password,
  ];
}

