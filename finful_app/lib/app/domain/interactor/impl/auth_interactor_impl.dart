import 'dart:async';

import 'package:finful_app/app/data/model/request/signin_request.dart';
import 'package:finful_app/app/data/model/request/signup_request.dart';
import 'package:finful_app/app/data/model/response/signin_response.dart';
import 'package:finful_app/app/data/model/response/signup_response.dart';
import 'package:finful_app/app/data/repository/auth_repository.dart';
import 'package:finful_app/app/data/repository/user_repository.dart';
import 'package:finful_app/app/domain/interactor/auth_interactor.dart';
import 'package:finful_app/core/datasource/config.dart';
import 'package:finful_app/core/extension/extension.dart';

class AuthInteractorImpl implements AuthInteractor {
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;

  AuthInteractorImpl({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) :
        _authRepository = authRepository,
        _userRepository = userRepository;

  @override
  Future<bool> submitLogout() async {
    final response = await _authRepository.submitLogout();
    final isSuccess = response.success ?? false;
    return isSuccess;
  }

  @override
  Future<SignInResponse?> submitSignIn({
    required String email,
    required String password
  }) async {
    final request = SignInRequest(
      email: email,
      password: password,
    );
    final response = await _authRepository.submitSignIn(request);

    if (response.userId == null) {
      return null;
    }
    if (response.token.isNullOrEmpty) {
      return null;
    }

    return response;
  }

  @override
  Future<SignUpResponse> submitSignUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final request = SignUpRequest(
        firstName: firstName,
        lastName: lastName,
        emailAddress: email,
        password: password,
        passwordVerification: password,
    );
    final response = await _authRepository.submitSignUp(request);
    return response;
  }

  @override
  Future<void> saveAuthorizationToLocal({
    required Authorization authorization,
  }) async {
    await _authRepository.saveAuthorizationToLocal(
        authorization: authorization);
  }

}