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
              const SizedBox(height: 24),
              Text('Acerca de', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Serena es una herramienta de práctica y no reemplaza el '
                          'acompañamiento de un fonoaudiólogo o terapeuta del habla. Si '
                          'sentís que necesitás ayuda profesional, te recomendamos '
                          'consultar con un especialista.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}