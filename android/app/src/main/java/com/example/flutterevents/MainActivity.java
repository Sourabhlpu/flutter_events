package com.example.flutterevents;

import android.os.Bundle;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.app.FlutterFragmentActivity;

public class MainActivity extends FlutterFragmentActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }
}
