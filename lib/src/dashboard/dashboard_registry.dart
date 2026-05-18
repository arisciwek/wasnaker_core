import 'dashboard_stat_widget.dart';
import 'dashboard_nav_item.dart';

const _membershipLevels = {
  'free': 0,
  'basic': 1,
  'pro': 2,
  'enterprise': 3,
};

/// Central registry — modules call [registerStat] and [registerNav] during init.
/// [DashboardPage] reads these to build the Statistik and Navigasi tabs.
class DashboardRegistry {
  DashboardRegistry._();

  static final List<DashboardStatWidget> _stats   = [];
  static final List<DashboardNavItem>    _navItems = [];

  // ── Registration ──────────────────────────────────────────────────────────

  static void registerStat(DashboardStatWidget widget) {
    _stats.add(widget);
    _stats.sort((a, b) => a.order.compareTo(b.order));
  }

  static void registerNav(DashboardNavItem item) {
    _navItems.add(item);
    _navItems.sort((a, b) => a.order.compareTo(b.order));
  }

  // ── Query ─────────────────────────────────────────────────────────────────

  static List<DashboardStatWidget> statsFor({
    required String clientType,
    String membership = 'free',
  }) {
    final level = _membershipLevels[membership] ?? 0;
    return _stats.where((w) {
      if (w.clientType != null && w.clientType != clientType) return false;
      if (w.minMembership != null) {
        if (level < (_membershipLevels[w.minMembership] ?? 0)) return false;
      }
      return true;
    }).toList();
  }

  static List<DashboardNavItem> navsFor({
    required String clientType,
    String membership = 'free',
  }) {
    final level = _membershipLevels[membership] ?? 0;
    return _navItems.where((item) {
      if (item.clientType != null && item.clientType != clientType) return false;
      if (item.minMembership != null) {
        if (level < (_membershipLevels[item.minMembership] ?? 0)) return false;
      }
      return true;
    }).toList();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static void clear() {
    _stats.clear();
    _navItems.clear();
  }
}
