import 'package:flutter/material.dart';

import '../theme/delivery_theme.dart';
import '../widgets/delivery_widgets.dart';

class DeliveryShell extends StatefulWidget {
  const DeliveryShell({super.key});
  @override
  State<DeliveryShell> createState() => _DeliveryShellState();
}

class _DeliveryShellState extends State<DeliveryShell> {
  int _tab = 0;
  bool _online = true;
  bool _hasActiveOrder = false;

  Future<void> _openDemoOrder() async {
    final accepted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const DeliveryOrderFlowPage()),
    );
    if (accepted == true) setState(() => _hasActiveOrder = false);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DeliveryHomePage(
        online: _online,
        onOnline: (value) => setState(() => _online = value),
        onOpenOrder: _openDemoOrder,
        onTab: (value) => setState(() => _tab = value),
      ),
      DeliveryOrdersPage(
        hasActiveOrder: _hasActiveOrder,
        onOpenOrder: _openDemoOrder,
      ),
      const DeliveryEarningsPage(),
      const DeliveryProfilePage(),
    ];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF101316), DeliveryColors.base, Color(0xFF17100C)],
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOutCubic,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, .02),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: KeyedSubtree(key: ValueKey(_tab), child: pages[_tab]),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (value) => setState(() => _tab = value),
        backgroundColor: DeliveryColors.screen,
        indicatorColor: DeliveryColors.orange.withValues(alpha: .16),
        height: 70,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Earnings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DeliveryHomePage extends StatelessWidget {
  const DeliveryHomePage({
    super.key,
    required this.online,
    required this.onOnline,
    required this.onOpenOrder,
    required this.onTab,
  });
  final bool online;
  final ValueChanged<bool> onOnline;
  final VoidCallback onOpenOrder;
  final ValueChanged<int> onTab;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(19, 12, 19, 26),
    children: [
      Row(
        children: [
          Container(
            width: 39,
            height: 39,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: DeliveryColors.raised,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Image.asset('assets/images/alpha_cart_logo.png'),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Alpha Cart  /  Delivery',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You’re all caught up.')),
            ),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      const SizedBox(height: 17),
      const Text(
        'Hi, Ravi 👋',
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w800,
          letterSpacing: -.5,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        online ? 'You are online and ready for orders' : 'You are offline',
        style: const TextStyle(color: DeliveryColors.muted, fontSize: 12),
      ),
      const SizedBox(height: 17),
      DeliveryClay(
        color: online ? const Color(0xFF12351F) : DeliveryColors.card,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                online ? Icons.bolt_rounded : Icons.power_settings_new,
                color: online ? DeliveryColors.green : DeliveryColors.muted,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    online ? 'You’re Online' : 'You’re Offline',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    online
                        ? 'Ready to receive delivery requests'
                        : 'Go online when you are ready',
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ),
            Switch(
              value: online,
              onChanged: onOnline,
              activeColor: DeliveryColors.green,
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      const Row(
        children: [
          Expanded(
            child: DeliveryMetric(
              title: 'Today’s earnings',
              value: '₹0',
              icon: Icons.currency_rupee,
              tint: Color(0xFF3A3214),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: DeliveryMetric(
              title: 'Orders',
              value: '0',
              icon: Icons.receipt_long_outlined,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      const Row(
        children: [
          Expanded(
            child: DeliveryMetric(
              title: 'Distance',
              value: '0.0 km',
              icon: Icons.route_outlined,
              tint: Color(0xFF152C3A),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: DeliveryMetric(
              title: 'Rating',
              value: '0.0 ★',
              icon: Icons.star_outline_rounded,
              tint: Color(0xFF35251B),
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      InkWell(
        onTap: onOpenOrder,
        borderRadius: BorderRadius.circular(20),
        child: DeliveryClay(
          color: const Color(0xFF292019),
          child: Row(
            children: [
              const Icon(
                Icons.notifications_active_outlined,
                color: DeliveryColors.orange,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'New order requests',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: const BoxDecoration(
                  color: DeliveryColors.red,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '0',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Quick actions',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          TextButton(
            onPressed: () => onTab(3),
            child: const Text(
              'Profile',
              style: TextStyle(color: DeliveryColors.orange, fontSize: 11),
            ),
          ),
        ],
      ),
      const SizedBox(height: 7),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.03,
        children: [
          DeliveryShortcut(
            icon: Icons.receipt_long_outlined,
            label: 'Orders',
            onTap: () => onTab(1),
          ),
          DeliveryShortcut(
            icon: Icons.payments_outlined,
            label: 'Earnings',
            onTap: () => onTab(2),
          ),
          DeliveryShortcut(
            icon: Icons.account_balance_outlined,
            label: 'Payout',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DeliveryPayoutPage()),
            ),
          ),
          DeliveryShortcut(
            icon: Icons.person_outline,
            label: 'Profile',
            onTap: () => onTab(3),
          ),
          DeliveryShortcut(
            icon: Icons.verified_user_outlined,
            label: 'KYC',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DeliveryKycPage()),
            ),
          ),
          DeliveryShortcut(
            icon: Icons.help_outline,
            label: 'Support',
            onTap: () => _support(context),
          ),
        ],
      ),
      const SizedBox(height: 20),
      const Text(
        'Your delivery activity',
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
      ),
      const SizedBox(height: 11),
      DeliveryClay(
        child: Row(
          children: [
            const Icon(Icons.insights_outlined, color: DeliveryColors.orange),
            const SizedBox(width: 11),
            const Expanded(
              child: Text(
                'Complete your first delivery to see your activity here.',
                style: TextStyle(
                  color: DeliveryColors.muted,
                  fontSize: 11,
                  height: 1.45,
                ),
              ),
            ),
            IconButton(
              onPressed: () => onTab(2),
              icon: const Icon(
                Icons.chevron_right,
                color: DeliveryColors.muted,
              ),
            ),
          ],
        ),
      ),
    ],
  );

  void _support(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    backgroundColor: DeliveryColors.screen,
    builder: (_) => const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Partner support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 12),
            Text(
              'Support chat will be available once your account is connected.',
              style: TextStyle(color: DeliveryColors.muted),
            ),
          ],
        ),
      ),
    ),
  );
}

class DeliveryShortcut extends StatelessWidget {
  const DeliveryShortcut({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(19),
    child: DeliveryClay(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: DeliveryColors.orange, size: 22),
          const SizedBox(height: 9),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}

class DeliveryOrdersPage extends StatelessWidget {
  const DeliveryOrdersPage({
    super.key,
    required this.hasActiveOrder,
    required this.onOpenOrder,
  });
  final bool hasActiveOrder;
  final VoidCallback onOpenOrder;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
    children: [
      const DeliveryHeader(
        title: 'Orders',
        subtitle: 'Requests and deliveries',
      ),
      const SizedBox(height: 17),
      const _DeliveryOrderFilters(),
      const SizedBox(height: 16),
      DeliveryClay(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demo request',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
            const SizedBox(height: 5),
            const Text(
              'A sample order lets you explore accept, pickup and OTP delivery.',
              style: TextStyle(
                color: DeliveryColors.muted,
                fontSize: 11,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 13),
            DeliveryButton(
              label: hasActiveOrder ? 'Continue delivery' : 'View demo request',
              icon: Icons.arrow_forward_rounded,
              onPressed: onOpenOrder,
            ),
          ],
        ),
      ),
    ],
  );
}

class _DeliveryOrderFilters extends StatefulWidget {
  const _DeliveryOrderFilters();
  @override
  State<_DeliveryOrderFilters> createState() => _DeliveryOrderFiltersState();
}

class _DeliveryOrderFiltersState extends State<_DeliveryOrderFilters> {
  int selected = 0;
  final labels = const ['New (0)', 'Ongoing (0)', 'Completed (0)'];
  @override
  Widget build(BuildContext context) => Row(
    children: List.generate(
      labels.length,
      (i) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: i == 2 ? 0 : 7),
          child: InkWell(
            onTap: () => setState(() => selected = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected == i
                    ? DeliveryColors.orange
                    : DeliveryColors.raised,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: selected == i
                      ? DeliveryColors.orange
                      : DeliveryColors.line,
                ),
              ),
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class DeliveryOrderFlowPage extends StatefulWidget {
  const DeliveryOrderFlowPage({super.key});
  @override
  State<DeliveryOrderFlowPage> createState() => _DeliveryOrderFlowPageState();
}

class _DeliveryOrderFlowPageState extends State<DeliveryOrderFlowPage> {
  int _stage = 0;
  final _otp = TextEditingController();
  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(_stage == 0 ? 'New order' : 'Order #AC00001'),
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_stage == 0) ...[
            DeliveryClay(
              color: const Color(0xFF1B2025),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: DeliveryColors.orange.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'FOOD DELIVERY',
                      style: TextStyle(
                        color: DeliveryColors.orange,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '₹0',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 34),
                  ),
                  const Text(
                    'Distance · 0.0 km',
                    style: TextStyle(color: DeliveryColors.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const DeliveryClay(
              child: Column(
                children: [
                  DeliveryLocation(
                    icon: Icons.storefront,
                    title: 'Pickup',
                    place: 'The Spice Haven',
                    address: 'BTM Layout',
                  ),
                  SizedBox(height: 17),
                  DeliveryLocation(
                    icon: Icons.location_on,
                    title: 'Drop',
                    place: 'Raghav Towers',
                    address: 'HSR Layout',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DeliveryButton(
              label: 'Accept order',
              icon: Icons.check,
              onPressed: () => setState(() => _stage = 1),
            ),
            const SizedBox(height: 9),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                foregroundColor: Colors.white,
                side: const BorderSide(color: DeliveryColors.line),
              ),
              child: const Text('Decline'),
            ),
          ] else if (_stage == 1) ...[
            const DeliveryHeader(
              title: 'Order details',
              subtitle: 'Pickup from The Spice Haven',
            ),
            const SizedBox(height: 16),
            const DeliveryClay(
              child: Column(
                children: [
                  DeliveryValueRow(label: 'Order ID', value: '#AC00001'),
                  DeliveryValueRow(label: 'Delivery fee', value: '₹0'),
                  DeliveryValueRow(label: 'Distance', value: '0.0 km'),
                  DeliveryValueRow(label: 'Items', value: '0'),
                ],
              ),
            ),
            const SizedBox(height: 13),
            _RouteCard(),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Navigation will open when maps are connected.',
                  ),
                ),
              ),
              icon: const Icon(Icons.navigation),
              label: const Text('Navigate to pickup'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                foregroundColor: Colors.white,
                side: const BorderSide(color: DeliveryColors.line),
              ),
            ),
            const SizedBox(height: 12),
            DeliveryButton(
              label: 'Arrived at pickup',
              icon: Icons.place_outlined,
              onPressed: () => setState(() => _stage = 2),
            ),
          ] else if (_stage == 2) ...[
            const SizedBox(height: 45),
            const Icon(
              Icons.shopping_bag_rounded,
              color: DeliveryColors.orange,
              size: 74,
            ),
            const SizedBox(height: 20),
            const Text(
              'Confirm pickup',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
            ),
            const SizedBox(height: 9),
            const Text(
              'Have you picked up the order from The Spice Haven?',
              textAlign: TextAlign.center,
              style: TextStyle(color: DeliveryColors.muted, height: 1.5),
            ),
            const SizedBox(height: 25),
            DeliveryButton(
              label: 'Yes, order picked up',
              icon: Icons.check,
              onPressed: () => setState(() => _stage = 3),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => setState(() => _stage = 1),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                foregroundColor: Colors.white,
                side: const BorderSide(color: DeliveryColors.line),
              ),
              child: const Text('Not yet'),
            ),
          ] else if (_stage == 3) ...[
            const SizedBox(height: 25),
            const Icon(
              Icons.verified_user_outlined,
              color: DeliveryColors.orange,
              size: 61,
            ),
            const SizedBox(height: 18),
            const Text(
              'Deliver order',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter the customer’s 4-digit delivery OTP.',
              textAlign: TextAlign.center,
              style: TextStyle(color: DeliveryColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 23),
            TextField(
              controller: _otp,
              maxLength: 4,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                letterSpacing: 12,
              ),
              decoration: const InputDecoration(
                hintText: '• • • •',
                counterText: 'Demo delivery code: 4839',
              ),
            ),
            const SizedBox(height: 16),
            DeliveryButton(
              label: 'Complete delivery',
              icon: Icons.check_circle_outline,
              onPressed: () {
                if (_otp.text.trim() != '4839') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('For this preview, enter 4839.'),
                    ),
                  );
                  return;
                }
                setState(() => _stage = 4);
              },
            ),
          ] else ...[
            const SizedBox(height: 65),
            const Icon(
              Icons.check_circle,
              color: DeliveryColors.green,
              size: 74,
            ),
            const SizedBox(height: 18),
            const Text(
              'Delivery completed',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 23),
            ),
            const SizedBox(height: 8),
            const Text(
              'Great work. Your demo delivery is complete.',
              textAlign: TextAlign.center,
              style: TextStyle(color: DeliveryColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 22),
            const DeliveryClay(
              child: DeliveryValueRow(
                label: 'Demo delivery earnings',
                value: '₹0',
                emphasized: true,
              ),
            ),
            const SizedBox(height: 22),
            DeliveryButton(
              label: 'Back to dashboard',
              icon: Icons.home_outlined,
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ],
      ),
    ),
  );
}

class DeliveryLocation extends StatelessWidget {
  const DeliveryLocation({
    super.key,
    required this.icon,
    required this.title,
    required this.place,
    required this.address,
  });
  final IconData icon;
  final String title, place, address;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(
        icon,
        color: title == 'Pickup' ? DeliveryColors.green : DeliveryColors.red,
        size: 20,
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: DeliveryColors.muted, fontSize: 10),
            ),
            const SizedBox(height: 3),
            Text(
              place,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
            Text(
              address,
              style: const TextStyle(color: DeliveryColors.muted, fontSize: 10),
            ),
          ],
        ),
      ),
    ],
  );
}

class _RouteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const DeliveryClay(
    child: Column(
      children: [
        DeliveryLocation(
          icon: Icons.storefront,
          title: 'Pickup',
          place: 'The Spice Haven',
          address: 'BTM Layout · 0.0 km',
        ),
        SizedBox(height: 14),
        DeliveryLocation(
          icon: Icons.location_on,
          title: 'Drop',
          place: 'Raghav Towers',
          address: 'HSR Layout · 0.0 km',
        ),
      ],
    ),
  );
}

class DeliveryEarningsPage extends StatelessWidget {
  const DeliveryEarningsPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
    children: [
      const DeliveryHeader(
        title: 'My earnings',
        subtitle: 'Your delivery earnings at a glance',
      ),
      const SizedBox(height: 17),
      const _EarningRange(),
      const SizedBox(height: 14),
      const DeliveryClay(
        color: Color(0xFF17211D),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '₹0',
              style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 4),
            Text(
              'Total earnings',
              style: TextStyle(color: DeliveryColors.muted, fontSize: 11),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      const DeliveryClay(
        child: Column(
          children: [
            DeliveryValueRow(label: 'Base earnings', value: '₹0'),
            DeliveryValueRow(label: 'Surge bonus', value: '₹0'),
            DeliveryValueRow(label: 'Distance bonus', value: '₹0'),
            DeliveryValueRow(label: 'Other incentives', value: '₹0'),
            Divider(color: DeliveryColors.line),
            DeliveryValueRow(
              label: 'Net earnings',
              value: '₹0',
              emphasized: true,
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      DeliveryClay(
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available payout balance',
                    style: TextStyle(color: DeliveryColors.muted, fontSize: 11),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '₹0',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeliveryPayoutPage()),
              ),
              child: const Text(
                'Payout',
                style: TextStyle(color: DeliveryColors.orange),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _EarningRange extends StatefulWidget {
  const _EarningRange();
  @override
  State<_EarningRange> createState() => _EarningRangeState();
}

class _EarningRangeState extends State<_EarningRange> {
  String selected = 'Today';
  @override
  Widget build(BuildContext context) => Row(
    children: ['Today', 'Week', 'Month']
        .map(
          (value) => Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 7),
              child: InkWell(
                onTap: () => setState(() => selected = value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected == value
                        ? DeliveryColors.orange
                        : DeliveryColors.raised,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: selected == value
                          ? DeliveryColors.orange
                          : DeliveryColors.line,
                    ),
                  ),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
        .toList(),
  );
}

class DeliveryPayoutPage extends StatelessWidget {
  const DeliveryPayoutPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('Payout'),
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const DeliveryClay(
          color: Color(0xFF1B2025),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available balance',
                style: TextStyle(color: DeliveryColors.muted, fontSize: 11),
              ),
              SizedBox(height: 7),
              Text(
                '₹0',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        DeliveryButton(
          label: 'Withdraw to bank',
          icon: Icons.account_balance_outlined,
          onPressed: () => _withdraw(context),
        ),
        const SizedBox(height: 18),
        const DeliveryClay(
          child: Column(
            children: [
              DeliveryValueRow(label: 'Payout history', value: '0 payouts'),
              Divider(color: DeliveryColors.line),
              DeliveryValueRow(label: 'Bank account', value: 'Not linked'),
              Divider(color: DeliveryColors.line),
              DeliveryValueRow(
                label: 'Earning statements',
                value: '0 statements',
              ),
            ],
          ),
        ),
      ],
    ),
  );
  void _withdraw(
    BuildContext context,
  ) => ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Available balance is ₹0. Payouts will be connected with the backend.',
      ),
    ),
  );
}

class DeliveryProfilePage extends StatelessWidget {
  const DeliveryProfilePage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
    children: [
      const DeliveryHeader(
        title: 'My profile',
        subtitle: 'Your partner account and settings',
      ),
      const SizedBox(height: 17),
      const DeliveryClay(
        child: Column(
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: DeliveryColors.raised,
              child: Icon(Icons.person, size: 42, color: DeliveryColors.muted),
            ),
            SizedBox(height: 12),
            Text(
              'Ravi Kumar',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: DeliveryColors.yellow, size: 15),
                SizedBox(width: 4),
                Text(
                  '0.0 rating  ·  0 reviews',
                  style: TextStyle(color: DeliveryColors.muted, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 15),
      _ProfileOption(
        icon: Icons.person_outline,
        title: 'Personal details',
        onTap: () => _info(context, 'Personal details'),
      ),
      _ProfileOption(
        icon: Icons.two_wheeler,
        title: 'Vehicle details',
        onTap: () => _info(context, 'Vehicle details'),
      ),
      _ProfileOption(
        icon: Icons.description_outlined,
        title: 'Documents (KYC)',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DeliveryKycPage()),
        ),
      ),
      _ProfileOption(
        icon: Icons.settings_outlined,
        title: 'Settings',
        onTap: () => _info(context, 'Settings'),
      ),
      _ProfileOption(
        icon: Icons.help_outline,
        title: 'Help & support',
        onTap: () => _info(context, 'Help & support'),
      ),
    ],
  );
  void _info(BuildContext context, String title) => showModalBottomSheet<void>(
    context: context,
    backgroundColor: DeliveryColors.screen,
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              'These account details will be managed from your verified partner profile.',
              style: TextStyle(color: DeliveryColors.muted),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: InkWell(
      onTap: onTap,
      child: DeliveryClay(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: DeliveryColors.orange, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: DeliveryColors.muted),
          ],
        ),
      ),
    ),
  );
}

class DeliveryKycPage extends StatelessWidget {
  const DeliveryKycPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('Documents & KYC'),
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        DeliveryClay(
          child: Column(
            children: [
              DeliveryValueRow(
                label: 'Profile verification',
                value: 'Complete',
              ),
              DeliveryValueRow(label: 'Identity documents', value: 'Submitted'),
              DeliveryValueRow(
                label: 'Vehicle verification',
                value: 'Submitted',
              ),
              DeliveryValueRow(label: 'Face verification', value: 'Complete'),
            ],
          ),
        ),
        SizedBox(height: 14),
        Text(
          'Verification status: In review',
          style: TextStyle(
            color: DeliveryColors.yellow,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
