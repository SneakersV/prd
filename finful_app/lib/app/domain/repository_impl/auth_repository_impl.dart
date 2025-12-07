import 'package:finful_app/app/data/datasource/local/auth_local_datasource.dart';
import 'package:finful_app/app/data/datasource/remote/auth_remote_datasource.dart';
import 'package:finful_app/app/data/model/response/logout_response.dart';
import 'package:finful_app/app/data/model/response/signin_response.dart';
import 'package:finful_app/app/data/model/response/signup_response.dart';
import 'package:finful_app/app/data/model/request/signin_request.dart';
import 'package:finful_app/app/data/model/request/signup_request.dart';
import 'package:finful_app/app/data/repository/auth_repository.dart';
import 'package:finful_app/core/datasource/config.dart';

class AuthRepositoryImpl implements AuthRepository {
  late final AuthLocalDatasource _authLocalDatasource;
  late final AuthRemoteDatasource _authRemoteDatasource;

  AuthRepositoryImpl({
    required AuthLocalDatasource authLocalDatasource,
    required AuthRemoteDatasource authRemoteDatasource,
  })  : _authLocalDatasource = authLocalDatasource,
        _authRemoteDatasource = authRemoteDatasource;

  @override
  Future<void> clearAuthorizationAtLocal() async {
    await _authLocalDatasource.clearAuthorization();
  }

  @override
  Authorization? getAuthorizationFromLocal() {
    return _authLocalDatasource.loadAuthorization();
  }

  @override
  Future<void> saveAuthorizationToLocal({
    required Authorization authorization
  }) async {
    await _authLocalDatasource.saveAuthorization(authorization);
  }

  @override
  Future<LogoutResponse> submitLogout() async {
    return await _authRemoteDatasource.postLogout();
  }

  @override
  Future<SignInResponse> submitSignIn(SignInRequest request) async {
    return await _authRemoteDatasource.postSignIn(request);
  }

  @override
  Future<SignUpResponse> submitSignUp(SignUpRequest request) async {
    return await _authRemoteDatasource.postSignUp(request);
  }
  
}