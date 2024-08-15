import "package:package_info_plus/package_info_plus.dart";
import "package:window_manager/window_manager.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter/material.dart";

import "package:koreugi/ui/.index.dart" as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const Size size = Size(1920 * 0.25, 1080 * 0.25);
  final packageInfo = await PackageInfo.fromPlatform();

  windowManager.waitUntilReadyToShow(
    WindowOptions(
      title: "${packageInfo.appName.toUpperCase()} v${packageInfo.version}",
      minimumSize: size,
      maximumSize: size,
      alwaysOnTop: true,
      center: true,
      size: size,
    ),
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );

  await dotenv.load(fileName: "assets/.env");

  runApp(const App());
}

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ui.Home(),
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
    );
  }
}
