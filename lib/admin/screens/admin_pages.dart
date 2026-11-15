import 'package:flutter/material.dart';
import 'package:alpha_cart_auth/alpha_cart_auth.dart';

import '../models/admin_models.dart';
import '../services/admin_api_service.dart';
import '../theme/admin_theme.dart';
import '../widgets/admin_widgets.dart';

import 'delivery_partners_screen.dart';
import 'payouts_screen.dart';
import 'products_screen.dart';
import 'profit_loss_screen.dart';
import 'settings_screen.dart';
import 'shops_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Period _period = Period.month;

  @override
  Widget build(BuildContext context) {
    final service = AdminApiService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final metrics = service.getDashboardMetrics(_period);
        final pendingKycCount =
            service.stores.where((s) => s.kycStatus == KycStatus.pending).length +
            service.riders.where((r) => r.kycStatus == KycStatus.pending).length;
        final pendingPayoutCount =
            service.payouts.where((p) => p.status == 'PENDING').length;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            // Top App Bar
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AdminColors.orange.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image.asset(
                      'assets/images/alpha_cart_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Alpha Cart  /  Admin',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                  onPressed: () => _snack(context, 'All systems operational'),
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
                InkWell(
                  onTap: () => _showAccountSheet(context),
                  borderRadius: BorderRadius.circular(20),
                  child: const CircleAvatar(
                    radius: 17,
                    backgroundColor: AdminColors.raised,
                    child: Icon(Icons.person, size: 19, color: AdminColors.muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            const Text(
              'Good morning, Adithya 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Here’s what’s happening with your business across Bengaluru.',
              style: TextStyle(color: AdminColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 18),

            // Period selector
            Row(
              children: [
                _periodPill('Today', Period.today),
                const SizedBox(width: 8),
                _periodPill('This Week', Period.week),
                const SizedBox(width: 8),
                _periodPill('This Month', Period.month),
              ],
            ),
            const SizedBox(height: 16),

            // 4 KPI Tiles with design-prescribed colors
            Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: 'Total orders',
                    value: metrics.totalOrders.toString(),
                    delta: '+${metrics.ordersDelta}%',
                    icon: Icons.shopping_bag_outlined,
                    tint: const Color(0xFF355141), // Green tint
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MetricCard(
                    title: 'Total sales',
                    value: metrics.formattedSales,
                    delta: '+${metrics.salesDelta}%',
                    icon: Icons.currency_rupee,
                    tint: const Color(0xFF291C3F), // Purple tint
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: 'Platform revenue',
                    value: metrics.formattedRevenue,
                    delta: '+${metrics.revenueDelta}%',
                    icon: Icons.trending_up,
                    tint: const Color(0xFF1E3550), // Blue tint
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MetricCard(
                    title: 'Net profit',
                    value: metrics.formattedProfit,
                    delta: '+${metrics.profitDelta}%',
                    icon: Icons.account_balance_wallet_outlined,
                    tint: const Color(0xFF4A2220), // Maroon tint
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Urgent alerts banner
            if (pendingKycCount > 0 || pendingPayoutCount > 0)
              ClayPanel(
                padding: const EdgeInsets.all(14),
                color: const Color(0xFF241B10),
                child: Row(
                  children: [
                    const Icon(Icons.notification_important_rounded, color: AdminColors.yellow),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Action Required',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AdminColors.yellow),
                          ),
                          Text(
                            '$pendingKycCount pending KYC approvals · $pendingPayoutCount pending payout settlements',
                            style: const TextStyle(fontSize: 11, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),

            // Quick Operations Row
            SectionHeading(
              title: 'Quick Actions',
              trailing: 'Manage',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProductsPage()),
                );
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _quickAction(
                  context,
                  title: 'Catalogue',
                  icon: Icons.inventory_2_outlined,
                  color: AdminColors.orange,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProductsPage()),
                  ),
                ),
                const SizedBox(width: 10),
                _quickAction(
                  context,
                  title: 'P&L Statement',
                  icon: Icons.query_stats,
                  color: AdminColors.purple,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfitLossPage()),
                  ),
                ),
                const SizedBox(width: 10),
                _quickAction(
                  context,
                  title: 'Payouts',
                  icon: Icons.payments_outlined,
                  color: AdminColors.yellow,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PayoutsPage()),
                  ),
                ),
                const SizedBox(width: 10),
                _quickAction(
                  context,
                  title: 'Sellers',
                  icon: Icons.storefront_outlined,
                  color: AdminColors.green,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ShopsPage()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Live recent orders
            SectionHeading(
              title: 'Live Order Activity',
              trailing: 'View all',
              onTap: () {},
            ),
            const SizedBox(height: 10),
            ...service.orders.take(3).map((o) => _orderTile(context, o, service)),
          ],
        );
      },
    );
  }

  Widget _periodPill(String title, Period p) {
    final active = _period == p;
    return InkWell(
      onTap: () => setState(() => _period = p),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AdminColors.orange : AdminColors.raised,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.w600,
            color: active ? Colors.white : AdminColors.muted,
          ),
        ),
      ),
    );
  }

  Widget _quickAction(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: ClayPanel(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderTile(BuildContext context, AdminOrder order, AdminApiService service) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClayPanel(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AdminColors.raised,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.receipt_outlined, color: AdminColors.orange, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.id,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        order.formattedTotal,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${order.storeName} · ${order.customerName}',
                    style: const TextStyle(color: AdminColors.muted, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Status: ${order.status.label} (${order.formattedTime})',
                    style: TextStyle(
                      color: order.status == AdminOrderStatus.delivered
                          ? AdminColors.green
                          : AdminColors.orange,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String _selectedTab = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final _tabs = [
    'All',
    'Placed',
    'Preparing',
    'On The Way',
    'Delivered',
    'Cancelled',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = AdminApiService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final filtered = service.orders.where((o) {
          bool matchesTab = true;
          if (_selectedTab == 'Placed') matchesTab = o.status == AdminOrderStatus.placed;
          if (_selectedTab == 'Preparing') matchesTab = o.status == AdminOrderStatus.preparing;
          if (_selectedTab == 'On The Way') matchesTab = o.status == AdminOrderStatus.onTheWay;
          if (_selectedTab == 'Delivered') matchesTab = o.status == AdminOrderStatus.delivered;
          if (_selectedTab == 'Cancelled') matchesTab = o.status == AdminOrderStatus.cancelled;

          final matchesQuery = _searchQuery.isEmpty ||
              o.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              o.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              o.storeName.toLowerCase().contains(_searchQuery.toLowerCase());

          return matchesTab && matchesQuery;
        }).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            const PageHeader(
              title: 'Orders',
              subtitle: 'Monitor and coordinate live customer orders',
            ),
            const SizedBox(height: 16),

            // Search
            TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v.trim()),
              decoration: InputDecoration(
                hintText: 'Search by Order ID, customer, or store...',
                prefixIcon: const Icon(Icons.search, color: AdminColors.muted),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AdminColors.muted),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 14),

            // Status Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _tabs.map((tab) {
                  final active = _selectedTab == tab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(tab),
                      selected: active,
                      selectedColor: AdminColors.orange,
                      backgroundColor: AdminColors.raised,
                      labelStyle: TextStyle(
                        color: active ? Colors.white : AdminColors.muted,
                        fontWeight: active ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      onSelected: (_) => setState(() => _selectedTab = tab),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              '${filtered.length} orders found',
              style: const TextStyle(color: AdminColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 10),

            if (filtered.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text('No orders match your filter criteria.', style: TextStyle(color: AdminColors.muted)),
                ),
              )
            else
              ...filtered.map((order) => _orderDetailCard(context, order, service)),
          ],
        );
      },
    );
  }

  Widget _orderDetailCard(BuildContext context, AdminOrder order, AdminApiService service) {
    Color statusColor;
    switch (order.status) {
      case AdminOrderStatus.delivered:
        statusColor = AdminColors.green;
        break;
      case AdminOrderStatus.cancelled:
      case AdminOrderStatus.refunded:
        statusColor = AdminColors.red;
        break;
      case AdminOrderStatus.onTheWay:
        statusColor = AdminColors.blue;
        break;
      default:
        statusColor = AdminColors.orange;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClayPanel(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      order.id,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${order.formattedTime})',
                      style: const TextStyle(color: AdminColors.muted, fontSize: 11),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: statusColor.withValues(alpha: .35)),
                  ),
                  child: Text(
                    order.status.label,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Store: ${order.storeName} (${order.storeAddress})',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              'Customer: ${order.customerName} (${order.customerPhone})',
              style: const TextStyle(color: AdminColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              'Address: ${order.deliveryAddress}',
              style: const TextStyle(color: AdminColors.muted, fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (order.deliveryOtp != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('Delivery OTP: ', style: TextStyle(color: AdminColors.muted, fontSize: 11)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AdminColors.raised,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      order.deliveryOtp!,
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AdminColors.orange, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            const Divider(color: AdminColors.line, height: 1),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.items.length} item(s) · ${order.items.map((i) => i.name).join(', ')}',
                  style: const TextStyle(color: AdminColors.muted, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  order.formattedTotal,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Order Status Advancement Buttons
            Row(
              children: [
                if (order.status == AdminOrderStatus.placed)
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AdminColors.orange),
                      onPressed: () => service.updateOrderStatus(order.id, AdminOrderStatus.confirmed),
                      child: const Text('Confirm Order', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                if (order.status == AdminOrderStatus.confirmed)
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AdminColors.orange),
                      onPressed: () => service.updateOrderStatus(order.id, AdminOrderStatus.preparing),
                      child: const Text('Mark Preparing', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                if (order.status == AdminOrderStatus.preparing)
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AdminColors.blue),
                      onPressed: () => service.updateOrderStatus(order.id, AdminOrderStatus.onTheWay),
                      child: const Text('Dispatch / On The Way', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                if (order.status == AdminOrderStatus.onTheWay)
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AdminColors.green),
                      onPressed: () => service.updateOrderStatus(order.id, AdminOrderStatus.delivered),
                      child: const Text('Mark Delivered', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                if (order.status != AdminOrderStatus.delivered && order.status != AdminOrderStatus.cancelled) ...[
                  const SizedBox(width: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AdminColors.red)),
                    onPressed: () => service.updateOrderStatus(order.id, AdminOrderStatus.cancelled),
                    child: const Text('Cancel', style: TextStyle(color: AdminColors.red, fontSize: 12)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ManagePage extends StatelessWidget {
  const ManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Products',
        'Update catalogue, stock and pricing',
        Icons.inventory_2_outlined,
        AdminColors.orange,
        const ProductsPage(),
      ),
      (
        'Shops & sellers',
        'Review and manage businesses and KYC',
        Icons.storefront_outlined,
        AdminColors.green,
        const ShopsPage(),
      ),
      (
        'Delivery partners',
        'Partner profiles, online status and fleet',
        Icons.delivery_dining,
        AdminColors.blue,
        const DeliveryPartnersPage(),
      ),
      (
        'Payouts & settlements',
        'Disburse merchant & rider earnings',
        Icons.payments_outlined,
        AdminColors.yellow,
        const PayoutsPage(),
      ),
      (
        'Profit & loss',
        'Revenue, commission and margin waterfall',
        Icons.account_balance_wallet_outlined,
        AdminColors.purple,
        const ProfitLossPage(),
      ),
      (
        'Settings & access',
        'Platform fees, safety switches and RBAC',
        Icons.settings_outlined,
        AdminColors.muted,
        const SettingsPage(),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        const PageHeader(
          title: 'Manage',
          subtitle: 'Operational controls across all platform entities',
        ),
        const SizedBox(height: 20),
        ClayPanel(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AdminColors.orange.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.tune_rounded, color: AdminColors.orange),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alpha Cart Business Controls',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '6 operational modules running the marketplace',
                      style: TextStyle(color: AdminColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ManageTile(
              title: item.$1,
              subtitle: item.$2,
              icon: item.$3,
              color: item.$4,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => item.$5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        const PageHeader(
          title: 'Reports & Analytics',
          subtitle: 'Understand how your business is scaling',
        ),
        const SizedBox(height: 20),
        const PeriodSelector(),
        const SizedBox(height: 16),
        const SalesChartCard(),
        const SizedBox(height: 18),
        const ClayPanel(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sales by Category',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 18),
              CategoryProgress(name: 'Food & Beverages', value: '45%', fraction: 0.45, color: AdminColors.orange),
              CategoryProgress(name: 'Gym & Fitness Gear', value: '25%', fraction: 0.25, color: AdminColors.purple),
              CategoryProgress(name: 'Use & Throw Disposables', value: '18%', fraction: 0.18, color: AdminColors.blue),
              CategoryProgress(name: 'Daily Grocery', value: '12%', fraction: 0.12, color: AdminColors.green),
            ],
          ),
        ),
      ],
    );
  }
}

void _snack(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );

void _showAccountSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AdminColors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Admin Account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          UserAccountCard(accentColor: AdminColors.orange),
          SizedBox(height: 16),
          SignOutTile(accentColor: AdminColors.orange),
        ],
      ),
    ),
  );
}
