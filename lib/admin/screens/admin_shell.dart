import 'package:flutter/material.dart';
import 'package:alpha_cart_auth/alpha_cart_auth.dart';

import '../theme/admin_theme.dart';
import 'admin_pages.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _tab = 0;
  final _pages = const [
    DashboardPage(),
    OrdersPage(),
    ManagePage(),
    ReportsPage(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF101114), AdminColors.base, Color(0xFF100E0C)],
        ),
      ),
      child: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, .025),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: KeyedSubtree(key: ValueKey(_tab), child: _pages[_tab]),
        ),
      ),
    ),
    bottomNavigationBar: LuxuryNavigationBar(
      selectedIndex: _tab,
      onTap: (value) => setState(() => _tab = value),
      accentColor: AdminColors.orange,
      items: const [
        LuxuryNavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home_rounded,
          label: 'Home',
        ),
        LuxuryNavItem(
          icon: Icons.receipt_long_outlined,
          activeIcon: Icons.receipt_long_rounded,
          label: 'Orders',
        ),
        LuxuryNavItem(
          icon: Icons.grid_view_outlined,
          activeIcon: Icons.grid_view_rounded,
          label: 'Manage',
        ),
        LuxuryNavItem(
          icon: Icons.bar_chart_outlined,
          activeIcon: Icons.bar_chart_rounded,
          label: 'Reports',
        ),
      ],
    ),
  );
}
