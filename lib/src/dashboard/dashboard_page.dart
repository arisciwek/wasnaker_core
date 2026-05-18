import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'dashboard_registry.dart';

/// Dashboard page — 2 fixed tabs: Statistik | Navigasi.
///
/// Modules register their content via [DashboardRegistry].
/// Place this as a page in the actor app's NavigationHub.
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

  String get _clientType =>
      Auth.data()?['staff']?['client_type'] ?? '';

  String get _membership => 'free'; // TODO: read from auth when API ready

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Statistik'),
            Tab(text: 'Navigasi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _StatistikTab(clientType: _clientType, membership: _membership),
          _NavigasiTab(clientType: _clientType, membership: _membership),
        ],
      ),
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
      clientType: clientType,
      membership: membership,
    );

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

// ── Navigasi tab ──────────────────────────────────────────────────────────────

class _NavigasiTab extends StatelessWidget {
  final String clientType;
  final String membership;

  const _NavigasiTab({required this.clientType, required this.membership});

  @override
  Widget build(BuildContext context) {
    final items = DashboardRegistry.navsFor(
      clientType: clientType,
      membership: membership,
    );

    if (items.isEmpty) {
      return const Center(child: Text('No navigation items'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return InkWell(
          onTap: item.onTap,
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
                const SizedBox(height: 8),
                Text(item.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }
}
