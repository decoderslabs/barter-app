import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..forward();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      final auth = ref.read(authProvider);
      if (auth.isLoading) {
        // Bootstrap still in progress — wait for it to settle
        ref.listenManual(authProvider, (_, next) {
          if (!next.isLoading && mounted) {
            _navigate(next);
          }
        });
      } else {
        _navigate(auth);
      }
    });
  }

  void _navigate(AuthState auth) {
    if (auth.isAuthenticated) {
      if (auth.role == AppRole.brand) {
        context.go('/brand/dashboard');
      } else {
        context.go('/creator/feed');
      }
    } else {
      context.go('/welcome');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3193D),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB3193D),
              Color(0xFF8B1330),
            ],
          ),
        ),
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Curves.easeOutBack,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExa3ZqY2Z0Y2Z0Y2Z0Y2Z0Y2Z0Y2Z0Y2Z0Y2Z0Y2Z0Y2Z0Y2Z0Y2Z0Y2Z0Y2Z0Y2Z0Y2Zw/giphy.gif',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.loop,
                            color: Colors.white,
                            size: 80,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'BARTER',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 12,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'The Curated Canvas for Exchange',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const Spacer(),
                SizedBox(
                  width: 120,
                  height: 3,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
