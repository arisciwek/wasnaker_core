import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../widgets/adaptive_layout.dart';
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
  String get _membership => 'free';

  Map<String, List<String>> get _capabilities {
    final raw = _staff?['capabilities'];
    if (raw == null || raw is! Map) return {};
    return raw.map((k, v) => MapEntry(k.toString(), List<String>.from(v)));
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
          unselectedLabelColor: Colors.grey.shade600,
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
          _NavigasiTab(clientType: _clientType, membership: _membership, capabilities: _capabilities, columns: 5),
        ],
      ),
    );
  }

  // ── Mobile — AppBar + Statistik + FAB ─────────────────────────────────────

  Widget _mobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _UserInfo(name: _userName, subtitle: _subtitle),
      ),
      body: _StatistikTab(clientType: _clientType, membership: _membership),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNavBottomSheet(context, _capabilities),
        child: const Icon(Icons.grid_view_rounded),
      ),
    );
  }

  void _showNavBottomSheet(BuildContext context, Map<String, List<String>> capabilities) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.45,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (_, scrollController) => _NavigasiBottomSheet(
          clientType: _clientType,
          membership: _membership,
          capabilities: capabilities,
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
                  ?.copyWith(color: Colors.grey.shade500)),
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
  final String clientType;
  final String membership;
  final Map<String, List<String>> capabilities;
  final int columns;
  const _NavigasiTab(
      {required this.clientType,
      required this.membership,
      this.capabilities = const {},
      this.columns = 4});

  @override
  Widget build(BuildContext context) {
    final items = DashboardRegistry.navsFor(
        clientType: clientType, membership: membership, capabilities: capabilities);

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
  final String clientType;
  final String membership;
  final Map<String, List<String>> capabilities;
  final ScrollController scrollController;

  const _NavigasiBottomSheet({
    required this.clientType,
    required this.membership,
    required this.scrollController,
    this.capabilities = const {},
  });

  @override
  Widget build(BuildContext context) {
    final items = DashboardRegistry.navsFor(
        clientType: clientType, membership: membership, capabilities: capabilities);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                    color: Colors.grey.shade300,
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
                (_, i) => _NavCard(item: items[i]),
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
  final dynamic item;
  const _NavCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        item.onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            item.icon,
            const SizedBox(height: 6),
            Text(item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
