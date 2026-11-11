import 'package:flutter/material.dart';

import '../theme/admin_theme.dart';
import '../widgets/admin_widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
    children: [
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
            onPressed: () => _snack(context, 'You’re all caught up'),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const CircleAvatar(
            radius: 17,
            backgroundColor: AdminColors.raised,
            child: Icon(Icons.person, size: 19, color: AdminColors.muted),
          ),
        ],
      ),
      const SizedBox(height: 23),
      const Text(
        'Good morning, Adithya 👋',
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w800,
          letterSpacing: -.5,
        ),
      ),
      const SizedBox(height: 5),
      const Text(
        'Here’s what’s happening with your business.',
        style: TextStyle(color: AdminColors.muted, fontSize: 13),
      ),
      const SizedBox(height: 20),
      const PeriodSelector(),
      const SizedBox(height: 16),
      const Row(
        children: [
          Expanded(
            child: MetricCard(
              title: 'Total orders',
              value: '0',
              delta: '0%',
              icon: Icons.shopping_bag_outlined,
              tint: Color(0xFF173F2B),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: MetricCard(
              title: 'Total sales',
              value: '₹0',
              delta: '0%',
              icon: Icons.currency_rupee,
              tint: Color(0xFF291C3F),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      const Row(
        children: [
          Expanded(
            child: MetricCard(
              title: 'Platform revenue',
              value: '₹0',
              delta: '0%',
              icon: Icons.account_balance_wallet_outlined,
              tint: Color(0xFF1E3550),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: MetricCard(
              title: 'Net profit',
              value: '₹0',
              delta: '0%',
              icon: Icons.trending_up_rounded,
              tint: Color(0xFF4A2220),
            ),
          ),
        ],
      ),
      const SizedBox(height: 22),
      SectionHeading(
        title: 'Sales overview',
        trailing: 'This month',
        onTap: () => _snack(context, 'Showing this month'),
      ),
      const SizedBox(height: 12),
      const SalesChartCard(),
      const SizedBox(height: 23),
      SectionHeading(
        title: 'Needs your attention',
        trailing: 'View all',
        onTap: () => _snack(context, 'All business alerts'),
      ),
      const SizedBox(height: 12),
      const AttentionRow(
        icon: Icons.storefront_outlined,
        title: '0 shops awaiting review',
        subtitle: 'Review seller applications',
        color: AdminColors.yellow,
      ),
      const SizedBox(height: 9),
      const AttentionRow(
        icon: Icons.payments_outlined,
        title: '0 payouts pending',
        subtitle: '₹0 ready to settle',
        color: AdminColors.orange,
      ),
      const SizedBox(height: 23),
      SectionHeading(
        title: 'Recent activity',
        trailing: 'See all',
        onTap: () => _snack(context, 'Recent activity'),
      ),
      const SizedBox(height: 12),
      const ClayPanel(
        child: Row(
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              color: AdminColors.muted,
              size: 18,
            ),
            SizedBox(width: 10),
            Text(
              'No activity yet',
              style: TextStyle(color: AdminColors.muted, fontSize: 12),
            ),
          ],
        ),
      ),
    ],
  );
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String filter = 'All';
  String query = '';
  final filters = const ['All', 'Ongoing', 'Completed', 'Cancelled'];
  final orders = const [
    (
      '#AC78432',
      'The Spice Haven',
      'Food · 10:42 AM',
      '₹0',
      Icons.lunch_dining,
      AdminColors.orange,
      'Ongoing',
    ),
    (
      '#AC78431',
      'Fresh Mart',
      'Grocery · 10:35 AM',
      '₹0',
      Icons.shopping_cart,
      AdminColors.green,
      'Ongoing',
    ),
    (
      '#AC78430',
      'FitZone',
      'Gym & Fitness · 10:20 AM',
      '₹0',
      Icons.fitness_center,
      AdminColors.purple,
      'Completed',
    ),
    (
      '#AC78429',
      'EcoPack',
      'Use & Throw · 09:56 AM',
      '₹0',
      Icons.inventory_2_outlined,
      AdminColors.yellow,
      'Cancelled',
    ),
    (
      '#AC78428',
      'Daily Basket',
      'Grocery · 09:41 AM',
      '₹0',
      Icons.local_grocery_store,
      AdminColors.green,
      'Completed',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final shown = orders.where((o) {
      final matchesFilter = filter == 'All' || o.$7 == filter;
      final searchable = '${o.$1} ${o.$2} ${o.$3}'.toLowerCase();
      return matchesFilter && searchable.contains(query.toLowerCase());
    }).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        const PageHeader(
          title: 'Orders',
          subtitle: 'Track and manage customer orders',
        ),
        const SizedBox(height: 18),
        TextField(
          onChanged: (value) => setState(() => query = value.trim()),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search by order ID, shop or customer',
          ),
        ),
        const SizedBox(height: 14),
        FilterChips(
          values: filters,
          selected: filter,
          onSelected: (value) => setState(() => filter = value),
        ),
        const SizedBox(height: 16),
        ...shown.map(
          (o) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OrderTile(
              id: o.$1,
              shop: o.$2,
              detail: o.$3,
              amount: o.$4,
              icon: o.$5,
              color: o.$6,
              status: o.$7,
            ),
          ),
        ),
      ],
    );
  }
}

class ManagePage extends StatelessWidget {
  const ManagePage({super.key});
  static const items = [
    (
      'Products',
      'Update catalogue, stock and pricing',
      Icons.inventory_2_outlined,
      AdminColors.orange,
    ),
    (
      'Shops & sellers',
      'Review and manage businesses',
      Icons.storefront_outlined,
      AdminColors.green,
    ),
    (
      'Delivery partners',
      'Partner profiles and availability',
      Icons.delivery_dining,
      AdminColors.blue,
    ),
    (
      'Payouts & settlements',
      'Review earnings and settlements',
      Icons.payments_outlined,
      AdminColors.yellow,
    ),
    (
      'Profit & loss',
      'Revenue, expenses and margins',
      Icons.account_balance_wallet_outlined,
      AdminColors.purple,
    ),
    (
      'Settings & access',
      'Business, roles and security',
      Icons.settings_outlined,
      AdminColors.muted,
    ),
  ];
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
    children: [
      const PageHeader(
        title: 'Manage',
        subtitle: 'Your business, all in one place',
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
            const SizedBox(width: 13),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Business controls',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '6 areas to keep Alpha Cart running',
                    style: TextStyle(color: AdminColors.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 17),
      ...items.map(
        (item) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ManageTile(
            title: item.$1,
            subtitle: item.$2,
            icon: item.$3,
            color: item.$4,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DetailPage(
                  title: item.$1,
                  subtitle: item.$2,
                  icon: item.$3,
                  color: item.$4,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
    children: [
      const PageHeader(
        title: 'Reports & analytics',
        subtitle: 'Understand how your business is growing',
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
              'Sales by category',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 18),
            CategoryProgress(
              name: 'Food',
              value: '0%',
              fraction: 0,
              color: AdminColors.orange,
            ),
            CategoryProgress(
              name: 'Grocery',
              value: '0%',
              fraction: 0,
              color: AdminColors.green,
            ),
            CategoryProgress(
              name: 'Gym & Fitness',
              value: '0%',
              fraction: 0,
              color: AdminColors.blue,
            ),
            CategoryProgress(
              name: 'Use & Throw',
              value: '0%',
              fraction: 0,
              color: AdminColors.yellow,
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      const ClayPanel(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top performing areas',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            SimpleDataRow(name: 'Bengaluru Urban', value: '₹0'),
            SimpleDataRow(name: 'Shivamogga', value: '₹0'),
            SimpleDataRow(name: 'Mysuru', value: '₹0'),
          ],
        ),
      ),
    ],
  );
}

class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
  final String title, subtitle;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(title),
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ClayPanel(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: .16),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AdminColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (title == 'Products') ...const [
          ProductRow(
            name: 'Chicken Biryani',
            category: 'Food',
            price: '₹0',
            icon: Icons.rice_bowl,
          ),
          ProductRow(
            name: 'Whey Protein (1 kg)',
            category: 'Gym & Fitness',
            price: '₹0',
            icon: Icons.fitness_center,
          ),
          ProductRow(
            name: 'Paper Cup (100 pcs)',
            category: 'Use & Throw',
            price: '₹0',
            icon: Icons.coffee,
          ),
          ProductRow(
            name: 'Tomato (1 kg)',
            category: 'Grocery',
            price: '₹0',
            icon: Icons.local_grocery_store,
          ),
        ],
        if (title == 'Shops & sellers') ...const [
          PartnerRow(
            name: 'The Spice Haven',
            info: 'Restaurant · Bengaluru',
            status: 'Open',
            active: true,
          ),
          PartnerRow(
            name: 'Fresh Mart',
            info: 'Grocery · Bengaluru',
            status: 'Open',
            active: true,
          ),
          PartnerRow(
            name: 'FitZone',
            info: 'Gym & Fitness · Mysuru',
            status: 'Closed',
            active: false,
          ),
        ],
        if (title == 'Delivery partners') ...const [
          PartnerRow(
            name: 'Ravi Kumar',
            info: '0.0 ★ · 0 deliveries',
            status: 'Online',
            active: true,
          ),
          PartnerRow(
            name: 'Manoj S',
            info: '0.0 ★ · 0 deliveries',
            status: 'Online',
            active: true,
          ),
          PartnerRow(
            name: 'Abhishek R',
            info: '0.0 ★ · 0 deliveries',
            status: 'Offline',
            active: false,
          ),
        ],
        if (title == 'Payouts & settlements') ...const [
          PayoutSummary(),
          PayoutRow(name: 'Pending payouts (0)', amount: '₹0'),
          PayoutRow(name: 'Scheduled payouts', amount: '₹0'),
        ],
        if (title == 'Profit & loss') ...const [PnlSummary()],
        if (title == 'Settings & access') ...const [
          SettingRow(
            title: 'Business profile',
            detail: 'Alpha Cart Pvt. Ltd.',
            icon: Icons.business_outlined,
          ),
          SettingRow(
            title: 'Commission & fees',
            detail: 'Category-wise commission',
            icon: Icons.percent_rounded,
          ),
          SettingRow(
            title: 'Delivery pricing',
            detail: 'Distance-based & incentives',
            icon: Icons.route_outlined,
          ),
          SettingRow(
            title: 'User & role management',
            detail: 'Admins, managers, access',
            icon: Icons.manage_accounts_outlined,
          ),
          SettingRow(
            title: 'System & security',
            detail: 'Logs, backup, permissions',
            icon: Icons.shield_outlined,
          ),
        ],
        const SizedBox(height: 12),
        if (title == 'Products')
          FilledButton.icon(
            onPressed: () => _snack(context, 'Add product form coming soon'),
            icon: const Icon(Icons.add),
            label: const Text('Add new product'),
          ),
        if (title == 'Payouts & settlements')
          FilledButton.icon(
            onPressed: () => _snack(context, 'Payout settlement prepared'),
            icon: const Icon(Icons.account_balance_wallet_outlined),
            label: const Text('Settle payouts'),
          ),
      ],
    ),
  );
}

void _snack(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
