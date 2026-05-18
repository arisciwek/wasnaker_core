import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Renders [mobile] on phones/tablets, [web] on wide screens (kIsWeb or width >= 1024).
class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? web;

  const AdaptiveLayout({super.key, required this.mobile, this.web});

  static bool isWide(BuildContext context) =>
      kIsWeb || MediaQuery.of(context).size.width >= 1024;

  @override
  Widget build(BuildContext context) {
    if (web != null && isWide(context)) return web!;
    return mobile;
  }
}
