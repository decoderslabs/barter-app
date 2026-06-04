import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barter_app/features/auth/sign_in_screen.dart';
import 'package:barter_app/theme/barter_theme.dart';

void main() {
  testWidgets('SignInScreen builds', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildBarterLightTheme(),
          home: const SignInScreen(),
        ),
      ),
    );
    expect(find.textContaining('Creator'), findsWidgets);
  });
}
