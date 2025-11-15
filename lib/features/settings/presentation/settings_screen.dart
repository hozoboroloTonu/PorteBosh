import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../app/theme/tokens.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
        subtitle: 'App preferences and info',
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Text('Appearance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.accentLight)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('System Default'),
                  value: ThemeMode.system,
                  groupValue: currentThemeMode,
                  onChanged: (val) {
                    if (val != null) ref.read(themeModeProvider.notifier).setThemeMode(val);
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Light Theme'),
                  value: ThemeMode.light,
                  groupValue: currentThemeMode,
                  onChanged: (val) {
                    if (val != null) ref.read(themeModeProvider.notifier).setThemeMode(val);
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark Theme'),
                  value: ThemeMode.dark,
                  groupValue: currentThemeMode,
                  onChanged: (val) {
                    if (val != null) ref.read(themeModeProvider.notifier).setThemeMode(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Data & Storage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.accentLight)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: const Text('Backup & Restore'),
              subtitle: const Text('Offline archive management'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/backup'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.accentLight)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About PorteBosh'),
              subtitle: const Text('Version 1.0.0 • Developed by Mahmud Tonmoy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/about'),
            ),
          ),
        ],
      ),
    );
  }
}
