import 'package:flutter/material.dart';

/// A statistical widget card registered by a module into the Dashboard Statistik tab.
///
/// Example:
/// ```dart
/// DashboardRegistry.registerStat(DashboardStatWidget(
///   clientType: 'surveyor',
///   order: 1,
///   builder: () => InspectionStatCard(),  // "Jadwal minggu ini: 5"
/// ));
/// ```
class DashboardStatWidget {
  /// Widget builder — called when the Statistik tab renders.
  final Widget Function() builder;

  /// Actor type filter. null = all actors.
  final String? clientType;

  /// Minimum membership plan. null = all plans.
  final String? minMembership;

  /// Sort order — lower number appears first (top-left).
  final int order;

  const DashboardStatWidget({
    required this.builder,
    this.clientType,
    this.minMembership,
    this.order = 99,
  });
}
