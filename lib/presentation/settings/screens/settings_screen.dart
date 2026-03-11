import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../cubit/theme_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings'),
            Text(
              'Preferences and account',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final user = authState is AuthAuthenticated ? authState.user : null;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 110),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: user?.image.isNotEmpty == true
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: user!.image,
                                  width: 68,
                                  height: 68,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => _InitialAvatar(text: user.firstName),
                                ),
                              )
                            : _InitialAvatar(text: user?.firstName ?? '?'),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.fullName ?? 'Unknown user', style: theme.textTheme.titleLarge),
                            const SizedBox(height: 2),
                            Text(
                              '@${user?.username ?? 'n/a'}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.email ?? '-',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text('Appearance', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    final isDark = themeMode == ThemeMode.dark;
                    return SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      title: const Text('Dark Mode'),
                      subtitle: Text(isDark ? 'Dark theme is active' : 'Light theme is active'),
                      secondary: Icon(isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
                      value: isDark,
                      onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Text('Account', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: Icon(Icons.logout_rounded, color: theme.colorScheme.error),
                  title: Text(
                    'Logout',
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error),
                  ),
                  subtitle: const Text('Sign out from this device'),
                  onTap: () => _showLogoutDialog(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(LogoutEvent());
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  final String text;
  const _InitialAvatar({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = text.isNotEmpty ? text[0].toUpperCase() : '?';
    return Text(
      initial,
      style: theme.textTheme.titleLarge?.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
      ),
    );
  }
}
