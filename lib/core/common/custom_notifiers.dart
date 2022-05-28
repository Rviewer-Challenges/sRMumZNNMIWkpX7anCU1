import 'package:flutter/foundation.dart';

class CustomValueNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  bool _isDisposed;

  CustomValueNotifier(
    this._value,
    [this._isDisposed = false]
  );

  @override
  T get value => _value;
  T _value;
  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    notifyListeners();
  }

  @override
  String toString() => '${describeIdentity(this)}($_value)';

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;

    super.dispose();
  }
}