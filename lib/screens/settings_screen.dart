import 'package:flutter/material.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (context, currentMode, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Apariencia', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('Claro'),
                      value: ThemeMode.light,
                      groupValue: currentMode,
                      onChanged: (mode) {
                        if (mode != null) setThemeMode(mode);
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Oscuro'),
                      value: ThemeMode.dark,
                      groupValue: currentMode,
                      onChanged: (mode) {
                        if (mode != null) setThemeMode(mode);
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Automático (según el sistema)'),
                      value: ThemeMode.system,
                      groupValue: currentMode,
                      onChanged: (mode) {
                        if (mode != null) setThemeMode(mode);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}