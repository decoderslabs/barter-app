import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/barter_theme.dart';

final _appRouter = createRouter();

class BarterApp extends StatelessWidget {
  const BarterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BARTER',
      debugShowCheckedModeBanner: false,
      theme: buildBarterLightTheme(),
      routerConfig: _appRouter,
    );
  }
}
