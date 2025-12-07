import 'package:finful_app/app/data/model/response/signin_response.dart';
import 'package:finful_app/app/data/model/response/signup_response.dart';
import 'package:finful_app/core/datasource/config.dart';

abstract interface class AuthInteractor {
  Future<bool> submitLogout();

  Future<SignInResponse?> submitSignIn({
    required String email,
    required String password,
 });

  Future<SignUpResponse> submitSignUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<void> saveAuthorizationToLocal({
    required Authorization authorization,
  });
}