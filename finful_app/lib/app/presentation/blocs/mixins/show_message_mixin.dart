
import 'dart:io';

import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/presentation/blocs/common/show_message/show_message_bloc.dart';
import 'package:finful_app/app/presentation/blocs/common/show_message/show_message_event.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/exception/api_error.dart';
import 'package:finful_app/core/exception/api_exception.dart';

mixin ShowMessageBlocMixin {
  void showSnackBarMessage({
    ShowMessageSnackBarType type = ShowMessageSnackBarType.info,
    String? title,
    String? message,
  }) {
    BlocManager().event<ShowMessageBloc>(
      BlocConstants.showMessage,
      ShowMessageSnackBarStarted(
        type: type,
        title: title,
        message: message,
      ),
    );
  }

  void handleError(Object? error) {
    String? title;
    String? message;
    switch (error.runtimeType) {
      case ApiError:
        title = (error as ApiError).error;
        message = error.message;
        break;
      case UnauthorisedException: //401
        final errorCast = error as UnauthorisedException;
        final errorMap = errorCast.error as Map<String, dynamic>?;
        final finalMessage = errorMap != null
            ? errorMap['error'] : 'common_error_unauthorized_message';
        title = 'common_error_unauthorized';
        message = finalMessage;
        break;
      case NotFoundException: //404
        final errorCast = error as NotFoundException;
        final errorMap = errorCast.error as Map<String, dynamic>?;
        final finalMessage = errorMap != null
            ? errorMap['error'] : 'common_error_not_found_message';
        title = 'common_error_not_found';
        message = finalMessage;
        break;
      case ServerErrorException: // 500
        final errorCast = error as ServerErrorException;
        final errorMap = errorCast.error as Map<String, dynamic>?;
        final finalMessage = errorMap != null
            ? errorMap['error'] : 'common_error_server_error_message';
        title = 'common_error_server_error';
        message = finalMessage;
        break;
      case SocketException:
        title = 'common_error_no_internet';
        message = 'common_error_no_internet_message';
        break;
      case BadRequestException: //400
        final errorCast = error as BadRequestException;
        final errorMap = errorCast.error as Map<String, dynamic>?;
        final finalMessage = errorMap != null
            ? errorMap['error'] : 'common_error_something_went_wrong_message';
        title = 'common_error_unauthorized';
        message = finalMessage;
        break;
      case ForbiddenException: //403
      case InvalidInputException:
      case InvalidResponseException:
      case UnProcessableEntityException: //422
      case PayloadTooLargeException: //413
      case ValidationException: // 409
      case FetchDataException:
      case Null:
      default:
        title = 'common_error_something_went_wrong';
        message = 'common_error_something_went_wrong_message';
        break;
    }
    return showSnackBarMessage(
      type: ShowMessageSnackBarType.error,
      title: title,
      message: message,
    );
  }
}
