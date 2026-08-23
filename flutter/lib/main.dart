import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/route_screen.dart';

final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);

Future<void> _loadSavedThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('themeMode');
  if (saved == 'dark') {
    themeModeNotifier.value = ThemeMode.dark;
  } else if (saved == 'light') {
    themeModeNotifier.value = ThemeMode.light;
  }
}

Future<void> setThemeMode(ThemeMode mode) async {
  themeModeNotifier.value = mode;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('themeMode', mode == ThemeMode.dark ? 'dark' : 'light');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadSavedThemeMode();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Serena',
          themeMode: currentMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF5B8DB8),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            cardTheme: const CardThemeData(
              elevation: 1,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF5B8DB8),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            cardTheme: const CardThemeData(
              elevation: 1,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            ),
          ),
          home: const RouteScreen(),
        );
      },
    );
  }
}