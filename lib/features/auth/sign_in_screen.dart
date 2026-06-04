import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../widgets/barter_appbar.dart';
import '../../widgets/barter_buttons.dart';
import '../../widgets/barter_text_field.dart' show BarterLabeledField;

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _username = TextEditingController();
  bool _isRegister = false;
  AppRole _registerRole = AppRole.creator;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _username.dispose();
    super.dispose();
  }

  void _navigateAfterAuth(AppRole role) {
    if (role == AppRole.brand) {
      context.go('/brand/dashboard');
    } else {
      context.go('/creator/feed');
    }
  }

  Future<void> _submit() async {
    final auth = ref.read(authProvider.notifier);
    if (_isRegister) {
      await auth.register(
        email: _email.text.trim(),
        password: _password.text,
        name: _name.text.trim(),
        username: _username.text.trim(),
        role: _registerRole,
      );
    } else {
      await auth.login(_email.text.trim(), _password.text);
    }
    if (!mounted) return;
    final state = ref.read(authProvider);
    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error!),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (state.user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isRegister
                ? 'Account created! Welcome, ${state.user!.name}.'
                : 'Welcome back, ${state.user!.name}!',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      _navigateAfterAuth(state.role);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: bc.background,
      appBar: const BarterAppBar(
        showBrandTitle: false,
        leading: BackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isRegister ? 'Create account' : 'Sign in',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Connect to the Barter API',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: bc.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              ...[
                BarterLabeledField(
                  controller: _email,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                BarterLabeledField(
                  controller: _password,
                  label: 'Password',
                ),
                if (_isRegister) ...[
                  const SizedBox(height: 16),
                  BarterLabeledField(
                    controller: _name,
                    label: 'Full name',
                  ),
                  const SizedBox(height: 16),
                  BarterLabeledField(
                    controller: _username,
                    label: 'Username',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Creator'),
                        selected: _registerRole == AppRole.creator,
                        onSelected: (_) =>
                            setState(() => _registerRole = AppRole.creator),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Brand'),
                        selected: _registerRole == AppRole.brand,
                        onSelected: (_) =>
                            setState(() => _registerRole = AppRole.brand),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                BarterPrimaryButton(
                  label: auth.isLoading
                      ? 'Please wait...'
                      : (_isRegister ? 'Register' : 'Sign in'),
                  onPressed: auth.isLoading ? null : _submit,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => _isRegister = !_isRegister),
                  child: Text(
                    _isRegister
                        ? 'Already have an account? Sign in'
                        : 'Need an account? Register',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
