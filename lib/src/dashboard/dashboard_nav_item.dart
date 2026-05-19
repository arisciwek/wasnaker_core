import 'package:flutter/material.dart';

/// A navigation shortcut registered by a module into the Dashboard Navigasi tab.
///
/// [iconBuilder] is called lazily at render time — safe to read Auth.data() inside.
///
/// Example:
/// ```dart
/// DashboardRegistry.registerNav(DashboardNavItem(
///   label: 'Inspections',
///   iconBuilder: () {
///     final icons = Auth.data()?['staff']?['feature_icons'] ?? {};
///     return FaIconMapper.fromClass(icons['inspections'] ?? 'fa-solid fa-file-invoice');
///   },
///   clientType: 'surveyor',
///   requiredCapability: 'inspections:view',
///   order: 1,
///   onTap: () => routeTo(InspectionsPage.path),
/// ));
/// ```
class DashboardNavItem {
  final String label;

  /// Lazy icon builder — called at render time, not at registration time.
  final Widget Function() iconBuilder;

  final VoidCallback onTap;

  /// Actor type filter. null = all actors.
  final String? clientType;

  /// Minimum membership plan. null = all plans.
  final String? minMembership;

  /// Perfex capability required. Format: 'feature:capability'.
  /// For 'view': passes if user has 'view' OR 'view_own'.
  /// null = always visible.
  final String? requiredCapability;

  /// Sort order — lower number appears first.
  final int order;

  const DashboardNavItem({
    required this.label,
    required this.iconBuilder,
    required this.onTap,
    this.clientType,
    this.minMembership,
    this.requiredCapability,
    this.order = 99,
  });
}
