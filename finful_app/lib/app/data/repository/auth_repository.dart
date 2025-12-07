import 'package:finful_app/app/data/model/response/logout_response.dart';
import 'package:finful_app/app/data/model/response/signin_response.dart';
import 'package:finful_app/app/data/model/response/signup_response.dart';
import 'package:finful_app/app/data/model/request/signin_request.dart';
import 'package:finful_app/app/data/model/request/signup_request.dart';
import 'package:finful_app/core/datasource/config.dart';

abstract interface class AuthRepository {
  Future<void> saveAuthorizationToLocal({
    required Authorization authorization,
  });

  Authorization? getAuthorizationFromLocal();

  Future<void> clearAuthorizationAtLocal();

  Future<LogoutResponse> submitLogout();

  Future<SignInResponse> submitSignIn(SignInRequest request);

  Future<SignUpResponse> submitSignUp(SignUpRequest request);
}