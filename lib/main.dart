import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

class _BarterProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value, ProviderContainer container) {
    debugPrint('[Riverpod] INIT ${provider.name ?? provider.runtimeType}');
  }

  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    debugPrint('[Riverpod] UPDATE ${provider.name ?? provider.runtimeType}');
  }

  @override
  void didDisposeProvider(ProviderBase<Object?> provider, ProviderContainer container) {
    debugPrint('[Riverpod] DISPOSE ${provider.name ?? provider.runtimeType}');
  }

  @override
  void providerDidFail(ProviderBase<Object?> provider, Object error, StackTrace stackTrace, ProviderContainer container) {
    debugPrint('[Riverpod] ERROR ${provider.name ?? provider.runtimeType}: $error');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    debugPrintRebuildDirtyWidgets = false;
    debugPrint('[Barter] App starting — debug mode');
  }
  runApp(
    ProviderScope(
      observers: [_BarterProviderObserver()],
      child: const BarterApp(),
    ),
  );
}
