import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../widgets/adaptive_layout.dart';

/// Abstract base for all Wasnaker actor app hub pages.
///
/// Extend this instead of [NavigationHub] to get adaptive layout automatically:
/// - **Mobile** (narrow): [NavigationHubLayout.bottomNav]
/// - **Web** (≥ 1024px): [NavigationHubLayout.topNav]
///
/// Usage:
/// ```dart
/// class DashboardPage extends WasnakerNavigationHub<DashboardPage> {
///   static RouteView path = ("/dashboard", (_) => DashboardPage());
///
///   DashboardPage() : super(() => {
///     0: NavigationTab(title: 'Home',        page: HomeTab(),        icon: Icon(Icons.home_outlined)),
///     1: NavigationTab(title: 'Inspections', page: InspectionsTab(), icon: Icon(Icons.search_outlined)),
///   });
/// }
/// ```
abstract class WasnakerNavigationHub<T extends StatefulWidget>
    extends NavigationHub<T> {
  WasnakerNavigationHub(super.pages);

  @override
  NavigationHubLayout? layout(BuildContext context) {
    if (AdaptiveLayout.isWide(context)) {
      return NavigationHubLayout.topNav();
    }
    return NavigationHubLayout.bottomNav();
  }
}
