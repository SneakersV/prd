
import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  final String? email;
  final String? password;

  const SignUpState({
    this.email,
    this.password,
  });

  @override
  List<Object?> get props => [
    email,
    password,
  ];
}

class SignUpInitial extends SignUpState {}

class SignUpInProgress extends SignUpState {}

class SignUpSuccess extends SignUpState {
  const SignUpSuccess({
    required String email,
    required String password,
  }) : super(
    email: email,
    password: password,
  );
}

class SignUpFailure extends SignUpState {}