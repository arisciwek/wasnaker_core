import 'package:flutter/material.dart';

/// A navigation shortcut registered by a module into the Dashboard Navigasi tab.
///
/// Example:
/// ```dart
/// DashboardRegistry.registerNav(DashboardNavItem(
///   label: 'Inspections',
///   icon: Icon(Icons.search),
///   clientType: 'surveyor',
///   order: 1,
///   onTap: () => routeTo(InspectionsPage.path),
/// ));
/// ```
class DashboardNavItem {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  /// Actor type filter. null = all actors.
  final String? clientType;

  /// Minimum membership plan. null = all plans.
  final String? minMembership;

  /// Sort order — lower number appears first.
  final int order;

  const DashboardNavItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.clientType,
    this.minMembership,
    this.order = 99,
  });
}
