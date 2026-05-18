import 'package:flutter/material.dart';

/// A navigation shortcut registered by a module into the Dashboard Navigasi tab.
///
/// Example:
/// ```dart
/// DashboardRegistry.registerNav(DashboardNavItem(
///   label: 'Inspections',
///   icon: Icon(Icons.search),
///   clientType: 'surveyor',
///   requiredCapability: 'inspections:view',  // view OR view_own both pass
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

  /// Perfex capability required. Format: 'feature:capability'.
  /// e.g. 'inspections:view', 'quotations:create', 'rfqs:view'
  /// For 'view': passes if user has 'view' OR 'view_own'.
  /// null = always visible (no capability check).
  final String? requiredCapability;

  /// Sort order — lower number appears first.
  final int order;

  const DashboardNavItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.clientType,
    this.minMembership,
    this.requiredCapability,
    this.order = 99,
  });
}
