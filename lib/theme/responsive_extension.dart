import 'package:flutter/widgets.dart';

extension ResponsiveX on BuildContext {
  bool get isWide => MediaQuery.sizeOf(this).width >= 900;
  bool get isMedium => MediaQuery.sizeOf(this).width >= 600;
}
