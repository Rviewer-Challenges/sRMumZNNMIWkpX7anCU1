import 'package:flutter/widgets.dart';

import '../../core/common/custom_notifiers.dart';
import '../../di/locator.dart';

class AppLifecycleObserver extends StatefulWidget {
  const AppLifecycleObserver({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver>
    with WidgetsBindingObserver {
  final CustomValueNotifier<AppLifecycleState> _appLifeCycleState =
      CustomValueNotifier(AppLifecycleState.inactive);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appLifeCycleState.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifeCycleState.value = state;

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    if (!locator.isRegistered<CustomValueNotifier<AppLifecycleState>>()) {
      locator.registerLazySingleton<CustomValueNotifier<AppLifecycleState>>(
        () => _appLifeCycleState,
      );
    }

    return widget.child;
  }
}
