import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../widgets/adaptive_layout.dart';

/// Base State class for all Wasnaker adaptive navigation hubs.
///
/// Overrides [layout] to return [NavigationHubLayout.bottomNav] on mobile
/// and [NavigationHubLayout.topNav] on web (kIsWeb || width >= 1024).
///
/// Usage — create two classes in your actor app:
/// ```dart
/// class DashboardPage extends NyStatefulWidget with BottomNavPageControls {
///   static RouteView path = ("/dashboard", (_) => DashboardPage());
///   DashboardPage({super.key})
///       : super(child: () => _DashboardPageState(), stateName: path.stateName());
///   static NavigationHubStateActions stateActions =
///       NavigationHubStateActions(path.stateName());
/// }
///
/// class _DashboardPageState extends WasnakerNavigationHubState<DashboardPage> {
///   _DashboardPageState() : super(() => {
///     0: NavigationTab.tab(title: 'Home', page: HomeTab(), icon: Icon(Icons.home_outlined)),
///   });
/// }
/// ```
abstract class WasnakerNavigationHubState<T extends NyStatefulWidget>
    extends NavigationHub<T> {
  WasnakerNavigationHubState(super.pages);

  @override
  NavigationHubLayout? layout(BuildContext context) {
    return AdaptiveLayout.isWide(context)
        ? NavigationHubLayout.topNav()
        : NavigationHubLayout.bottomNav();
  }
}
