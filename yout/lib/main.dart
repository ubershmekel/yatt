import 'package:flutter/material.dart';
import 'package:yout/src/settings/globals.dart';

import 'src/app.dart';

void main() async {
  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  WidgetsFlutterBinding.ensureInitialized();
  final globals = Globals();
  await globals.init();
  runApp(MyApp(globals: globals));
}
