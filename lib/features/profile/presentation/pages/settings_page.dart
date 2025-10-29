import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  const SettingsPage({
    super.key,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Тёмная тема'),
            value: isDarkTheme,
            onChanged: onThemeChanged,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('О приложении'),
            subtitle: const Text('Версия 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
