import 'dart:async';

import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class JdEventBus {
  static StreamSubscription ss;

  static fire(event) {
    eventBus.fire(event);
  }

  static listen<T>(Function(T ev) callback) {
    ss = eventBus.on<T>().listen((event) {
      callback(event);
    });
  }

  static cancel() {
    ss.cancel();
  }
}

class EbAddressList {
  String msg;
  EbAddressList(this.msg);
}

class EbOneAddressList {
  String msg;
  EbOneAddressList(this.msg);
}
