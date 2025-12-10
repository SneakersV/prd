import 'package:finful_app/app/data/datasource/remote/user_remote_datasource.dart';
import 'package:finful_app/app/data/model/response/delete_account_response.dart';
import 'package:finful_app/app/data/model/response/user_extra_info_response.dart';
import 'package:finful_app/app/data/model/response/user_info_response.dart';
import 'package:finful_app/core/datasource/base_remote.dart';
import 'package:finful_app/core/datasource/config.dart';

class UserRemoteDatasourceImpl extends BaseRemote implements UserRemoteDatasource {
  late final String _host;

  UserRemoteDatasourceImpl({
    required String host,
    required super.config,
    super.getAuthorization,
  })  : _host = host;

  @override
  Future<UserInfoResponse> getCurrentUserInfo() async {
    final url = '$_host/auth/mobile';
    final json = await get(url, ApiHeaderType.withToken);
    return UserInfoResponse.fromJson(json);
  }

  @override
  Future<UserExtInfoResponse> getCurrentUserExtraInfo() async {
    final url = '$_host/user';
    final json = await get(url, ApiHeaderType.withToken);
    return UserExtInfoResponse.fromJson(json);
  }

  @override
  Future<DeleteAccountResponse> postDeleteAccount() async {
    final url = '$_host/user/delete';
    final json =
    await delete(url, ApiHeaderType.withToken);
    return DeleteAccountResponse.fromJson(json);
  }
}