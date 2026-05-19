import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../widgets/adaptive_layout.dart';
import '../icons/fa_icon_mapper.dart';
import 'dashboard_registry.dart';

/// Dashboard page — adaptive layout.
///
/// **Mobile**: Statistik only + FAB BottomSheet for Navigasi shortcuts.
/// **Web**: AppBar with TopTabBar (Statistik | Navigasi).
///
/// User name + company always visible in AppBar.
/// Modules register content via [DashboardRegistry].
class DashboardPage extends NyStatefulWidget {
  static RouteView path = ("/dashboard", (_) => DashboardPage());

  DashboardPage({super.key})
      : super(child: () => _DashboardPageState());
}

class _DashboardPageState extends NyPage<DashboardPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  get init => () {
    _tabController = TabController(length: 2, vsync: this);
  };

  @override
  LoadingStyle get loadingStyle => LoadingStyle.none();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Map? get _staff      => Auth.data()?['staff'];
  String get _clientType => _staff?['client_type'] ?? '';
  String get _membership =>
      Auth.data()?['staff']?['membership']?['plan'] ?? 'free';

  /// Reads menu_items directly from Perfex JWT response — always fresh.
  List<Map> get _menuItems {
    final raw = _staff?['menu_items'];
    if (raw == null || raw is! List) return [];
    return List<Map>.from(raw);
  }

  String get _userName =>
      '${_staff?['firstname'] ?? ''} ${_staff?['lastname'] ?? ''}'.trim();
  String get _subtitle =>
      _staff?['company_name'] ?? _staff?['role'] ?? '';

  @override
  Widget view(BuildContext context) {
    return AdaptiveLayout.isWide(context)
        ? _webLayout(context)
        : _mobileLayout(context);
  }

  // ── Web — AppBar + TopTabBar ──────────────────────────────────────────────

  Widget _webLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _UserInfo(name: _userName, subtitle: _subtitle),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(icon: Icon(Icons.bar_chart_outlined), text: 'Statistik'),
            Tab(icon: Icon(Icons.grid_view_outlined), text: 'Navigasi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _StatistikTab(clientType: _clientType, membership: _membership),
          _NavigasiTab(items: _menuItems, columns: 5),
        ],
      ),
    );
  }

  // ── Mobile — AppBar + Statistik + FAB ─────────────────────────────────────

  Widget _mobileLayout(BuildContext context) {
    final items = _menuItems;
    return Scaffold(
      appBar: AppBar(
        title: _UserInfo(name: _userName, subtitle: _subtitle),
      ),
      body: _StatistikTab(clientType: _clientType, membership: _membership),
      floatingActionButton: items.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showNavBottomSheet(context, items),
              child: const Icon(Icons.grid_view_rounded),
            )
          : null,
    );
  }

  void _showNavBottomSheet(BuildContext context, List<Map> items) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.45,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (_, scrollController) => _NavigasiBottomSheet(
          items: items,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

// ── User info widget (AppBar title) ──────────────────────────────────────────

class _UserInfo extends StatelessWidget {
  final String name;
  final String subtitle;
  const _UserInfo({required this.name, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        if (subtitle.isNotEmpty)
          Text(subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

// ── Statistik tab ─────────────────────────────────────────────────────────────

class _StatistikTab extends StatelessWidget {
  final String clientType;
  final String membership;
  const _StatistikTab({required this.clientType, required this.membership});

  @override
  Widget build(BuildContext context) {
    final widgets = DashboardRegistry.statsFor(
        clientType: clientType, membership: membership);

    if (widgets.isEmpty) {
      return const Center(child: Text('No statistics available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: widgets.map((w) => w.builder()).toList(),
      ),
    );
  }
}

// ── Navigasi tab (web) ────────────────────────────────────────────────────────

class _NavigasiTab extends StatelessWidget {
  final List<Map> items;
  final int columns;
  const _NavigasiTab({required this.items, this.columns = 4});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No navigation items'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _NavCard(item: items[i]),
    );
  }
}

// ── Navigasi BottomSheet (mobile FAB) ─────────────────────────────────────────

class _NavigasiBottomSheet extends StatelessWidget {
  final List<Map> items;
  final ScrollController scrollController;

  const _NavigasiBottomSheet({
    required this.items,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(80),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Menu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _NavCard(item: items[i], dismissOnTap: true),
                childCount: items.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Nav card ──────────────────────────────────────────────────────────────────

class _NavCard extends StatelessWidget {
  final Map item;
  final bool dismissOnTap;
  const _NavCard({required this.item, this.dismissOnTap = false});

  @override
  Widget build(BuildContext context) {
    final label = item['label'] as String? ?? '';
    final icon  = item['icon']  as String? ?? 'fa-solid fa-circle';

    return InkWell(
      onTap: () {
        if (dismissOnTap) Navigator.pop(context);
        // onTap routing — module sets this via DashboardNavItem in full arch
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIconMapper.fromClass(icon),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
