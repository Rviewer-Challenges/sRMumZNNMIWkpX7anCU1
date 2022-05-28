import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey;

  Function? _deferredNavigation;

  NavigationService(this._navigatorKey);

  Future pushNamed<T>(String routeName) async {
    try {
      return _navigatorKey.currentState?.pushNamed(routeName);
    } on Exception catch (error) {
      if (kDebugMode) {
        print('Exception occurred in navigationTo: $error');
      }
    }
  }

  Future pushNamedWithArguments<T>(String routeName, Object? argument) async {
    try {
      return _navigatorKey.currentState
          ?.pushNamed(routeName, arguments: argument);
    } on Exception catch (error) {
      if (kDebugMode) {
        print('Exception occurred in navigationTo: $error');
      }
    }
  }

  Future pushNamedWithThen<T>(
      String routeName, Function(dynamic) function) async {
    try {
      return _navigatorKey.currentState
          ?.pushNamed(routeName)
          .then((value) => function);
    } on Exception catch (error) {
      if (kDebugMode) {
        print('Exception occurred in navigationTo: $error');
      }
    }
  }

  Future pushNamedWithArgumentsWithThen<T>(
      String routeName, Object? argument, Function(dynamic) function) async {
    try {
      return _navigatorKey.currentState
          ?.pushNamed(routeName, arguments: argument)
          .then((value) => function);
    } on Exception catch (error) {
      if (kDebugMode) {
        print('Exception occurred in navigationTo: $error');
      }
    }
  }

  Future pushNamedAndRemoveUntil<T>(String routeName) async {
    try {
      return _navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(routeName, (route) => false);
    } on Exception catch (error) {
      if (kDebugMode) {
        print('Exception occurred in navigationTo: $error');
      }
    }
  }

  Future pushNamedAndRemoveUntilWithDeferredNavigation<T>(
      String routeName) async {
    try {
      _navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(routeName, (route) => false);

      if (_deferredNavigation != null) {
        _deferredNavigation!.call();
        _deferredNavigation = null;
      }
    } on Exception catch (error) {
      if (kDebugMode) {
        print('Exception occurred in navigationTo: $error');
      }
    }
  }

  Future pop() async {
    try {
      return _navigatorKey.currentState?.pop();
    } on Exception catch (error) {
      if (kDebugMode) {
        print('Exception occurred in pop: $error');
      }
    }
  }

  Future popUntil<T>(String routeName) async {
    try {
      return _navigatorKey.currentState
          ?.popUntil((route) => route.settings.name == routeName);
    } on Exception catch (error) {
      if (kDebugMode) {
        print('Exception occurred in pop: $error');
      }
    }
  }

  Future pushReplacement<T>(String routeName, [Object? argument]) async {
    try {
      return _navigatorKey.currentState
          ?.pushReplacementNamed(routeName, arguments: argument);
    } on Exception catch (error) {
      if (kDebugMode) {
        print('Exception occurred in pushReplacementNamed: $error');
      }
    }
  }

  // deferred navigation
  void setDeferredNavigation(Function? deferredNavigation) =>
      _deferredNavigation = deferredNavigation;
}
