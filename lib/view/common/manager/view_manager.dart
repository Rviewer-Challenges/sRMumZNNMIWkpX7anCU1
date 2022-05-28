import '../../../core/core/core_manager.dart';
import '../../../domain/common/error_type.dart';
import '../../utils/router.dart';

abstract class ViewManager extends CoreManager {
  runRequest<T>({
    required Function functionRequest,
    Function(T)? onSuccess,
    Function(ErrorType, String)? onError,
    bool isRetrying = false,
  }) async {
    var result = await functionRequest.call();
    result.when(
      success: (response) => onSuccess?.call(response),
      error: (errorType, message) => onError?.call(errorType, message),
    );

    return result;
  }

  // navigation
  void navigateToHome() => navigationService.popUntil(AppRouter.homeRoute);
}
