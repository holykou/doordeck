package com.tengio.doordeck;

import android.content.Context;
import android.nfc.NfcAdapter;
import android.nfc.NfcManager;

import com.doordeck.sdk.common.events.UnlockCallback;
import com.doordeck.sdk.common.manager.Doordeck;
import com.doordeck.sdk.common.manager.ScanType;
import java.util.ArrayList;
import android.app.Activity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** DoordeckPlugin */
public class DoordeckPlugin implements MethodCallHandler {
  /** Plugin registration. */
  private final Activity activity;
  private MethodChannel channel;
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "doordeck");
    DoordeckPlugin instance = new DoordeckPlugin(registrar.activity());
    channel.setMethodCallHandler(instance);
    instance.channel = channel;
  }

  private DoordeckPlugin(Activity activity) {
    this.activity = activity;
  }
  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }
    else if(call.method.equals("initDoordeck")) {
      ArrayList args = call.arguments();
      if (args.get(0) != null) {
          String authToken = (String)args.get(0);
        Doordeck.INSTANCE.initialize(this.activity.getApplicationContext(), authToken, false);
      }

    }
    else if(call.method.equals("showUnlock")) {
      ScanType type = ScanType.QR;
      NfcManager manager = (NfcManager) this.activity.getApplicationContext().getSystemService(Context.NFC_SERVICE);
      NfcAdapter adapter = manager.getDefaultAdapter();
      if (adapter != null && adapter.isEnabled()) {
        type = ScanType.NFC;
      }
      Doordeck.INSTANCE.showUnlock(this.activity.getApplicationContext(), type, new UnlockCallback() {
        @Override
        public void unlockSuccess() {
          channel.invokeMethod("unlockSuccessful", null);
        }

        @Override
        public void unlockFailed() {
          channel.invokeMethod("unlockFailed", null);

        }

        @Override
        public void invalidAuthToken() {
          channel.invokeMethod("invalidAuthToken", null);

        }

        @Override
        public void notAuthenticated() {
          channel.invokeMethod("verificationNeeded", null);
        }
      });
    }else {
      result.notImplemented();
    }

  }
}
