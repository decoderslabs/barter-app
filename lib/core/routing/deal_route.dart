import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Reads deal UUID from routes like `/deal/:id/...`.
String? dealIdFromRoute(BuildContext context) {
  final segments = GoRouterState.of(context).uri.pathSegments;
  if (segments.length >= 2 && segments.first == 'deal') {
    return segments[1];
  }
  final param = GoRouterState.of(context).pathParameters['id'];
  return param;
}
