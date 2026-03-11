import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginEvent(
              username: _usernameController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
                theme.scaffoldBackgroundColor,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.workspace_premium_rounded,
                        size: 54,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Welcome back',
                        style: theme.textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue to your dashboard and manage your content.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Account credentials',
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 14),
                                TextFormField(
                                  controller: _usernameController,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    labelText: 'Username',
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Enter username'
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  onFieldSubmitted: (_) => _login(),
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon:
                                        const Icon(Icons.lock_outline_rounded),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      ),
                                    ),
                                  ),
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Enter password'
                                      : null,
                                ),
                                const SizedBox(height: 18),
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    final isLoading = state is AuthLoading;
                                    return FilledButton.icon(
                                      onPressed: isLoading ? null : _login,
                                      icon: isLoading
                                          ? const SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Icon(Icons.login_rounded),
                                      label: Text(
                                        isLoading ? 'Signing in...' : 'Sign In',
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Demo credentials are prefilled for quick access.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
