import '../../di/locator.dart';
import '../common/custom_notifiers.dart';
import '../common/status.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';

abstract class CoreManager {
  final NavigationService navigationService = locator<NavigationService>();
  final DialogService dialogService = locator<DialogService>();

  final CustomValueNotifier<Status> _status =
      CustomValueNotifier(Status.initialized);
  CustomValueNotifier<Status> get status => _status;

  void loading() => _status.value = Status.loading;

  void loaded(bool isSuccess) =>
      _status.value = isSuccess ? Status.success : Status.failure;

  void dispose() {
    _status.dispose();
  }
}
