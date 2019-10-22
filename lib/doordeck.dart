import 'dart:async';

import 'package:flutter/services.dart';

class Doordeck {
  static const MethodChannel _channel = const MethodChannel('doordeck');
  DoordeckCallbackClass callback;
  Doordeck(this.callback);
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<bool> initDoordeck(String authToken) async {
    final bool success = await _channel.invokeMethod('initDoordeck', [authToken]);
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "authenticated") {
        this.callback.authenticated();
      }
      if (call.method == "verificationNeeded") {
        this.callback.verificationNeeded();
      }
      if (call.method == "unlockSuccessful") {
        this.callback.unlockSuccessful();
      }
      if (call.method == "invalidAuthToken") {
        this.callback.invalidAuthToken();
      }
    });
    return success;
  }

  Future<bool> showUnlock() async {
    final bool success = await _channel.invokeMethod("showUnlock");
    return success;
  }
}

abstract class DoordeckCallbackClass {
  void authenticated();
  void invalidAuthToken();
  void verificationNeeded();
  void unlockSuccessful();
  void unlockFailed();
}
