import "package:package_info_plus/package_info_plus.dart";
import "package:window_manager/window_manager.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";

import "package:amos_environment_runner/usecase/.index.dart" as usecase;
import "package:amos_environment_runner/infra/.index.dart" as infra;
import "package:amos_environment_runner/ui/.index.dart" as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const Size size = Size(1920 * 0.25, 1080 * 0.25);
  final packageInfo = await PackageInfo.fromPlatform();

  windowManager.waitUntilReadyToShow(
    WindowOptions(
      title: "AMOS Environment Runner v${packageInfo.version}",
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

  runApp(
    const DependencyInjector(
      child: App(),
    ),
  );
}

final class DependencyInjector extends StatelessWidget {
  const DependencyInjector({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => infra.ConfigurationImporter()..import(),
        ),
        BlocProvider(
          create: (_) => usecase.DismissSetting()..init(),
        ),
        BlocProvider(
          create: (_) => usecase.EnvironmentRunner(),
        ),
      ],
      child: const App(),
    );
  }
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
