
import 'package:finful_app/core/constant/model_constant.dart';

class SignUpResponse {
  final bool? success;
  final String? userId;

  SignUpResponse({
    this.success,
    this.userId,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      success: json['success'] ?? false,
      userId: json['userId'] ?? kString,
    );
  }
}