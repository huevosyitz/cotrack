import 'package:flutter/foundation.dart';

class AlwaysNotifyValueNotifier<T> extends ValueNotifier<T> {
  AlwaysNotifyValueNotifier(super.value);

  @override
  set value(T newValue) {
    super.value = newValue;
    notifyListeners(); // Always notify, even if same
  }
}
