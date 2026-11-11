import 'package:flutter/material.dart';

import '../theme/seller_theme.dart';
import '../widgets/seller_widgets.dart';

class SellerProduct {
  SellerProduct({
    required this.name,
    required this.category,
    this.price = 0,
    this.available = true,
  });
  String name;
  String category;
  int price;
  bool available;
}

class SellerShell extends StatefulWidget {
  const SellerShell({
    super.key,
    required this.shopName,
    required this.businessType,
  });
  final String shopName, businessType;
  @override
  State<SellerShell> createState() => _SellerShellState();
}

class _SellerShellState extends State<SellerShell> {
  int _tab = 0;
  bool _shopOpen = true;
  final _products = [
    SellerProduct(name: 'Chicken Biryani', category: 'Food'),
    SellerProduct(name: 'Veg Biryani', category: 'Food'),
    SellerProduct(name: 'Paneer Tikka', category: 'Food'),
  ];

  void _addProduct(SellerProduct product) =>
      setState(() => _products.insert(0, product));

  @override
  Widget build(BuildContext context) {
    final pages = [
      SellerHomePage(
        shopName: widget.shopName,
        businessType: widget.businessType,
        isOpen: _shopOpen,
        onShopTap: _openShopStatus,
        onShopChanged: (open) => setState(() => _shopOpen = open),
        onTab: (tab) => setState(() => _tab = tab),
        onEarnings: _openEarnings,
      ),
      const SellerOrdersPage(),
      SellerProductsPage(
        products: _products,
        onAdd: _showAddProduct,
        onChanged: () => setState(() {}),
      ),
      const SellerReportsPage(),
    ];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF101713), SellerColors.base, Color(0xFF15100C)],
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOutCubic,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, .02),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: KeyedSubtree(key: ValueKey(_tab), child: pages[_tab]),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        backgroundColor: SellerColors.screen,
        indicatorColor: SellerColors.orange.withValues(alpha: .16),
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
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
      ),
    );
  }

  Future<void> _openShopStatus() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ShopStatusPage(initiallyOpen: _shopOpen),
      ),
    );
    if (result != null) setState(() => _shopOpen = result);
  }

  void _openEarnings() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const SellerEarningsPage()),
  );

  Future<void> _showAddProduct() async {
    final product = await showModalBottomSheet<SellerProduct>(
      context: context,
      isScrollControlled: true,
      backgroundColor: SellerColors.screen,
      builder: (_) => const AddProductSheet(),
    );
    if (product != null) _addProduct(product);
  }
}

class SellerHomePage extends StatelessWidget {
  const SellerHomePage({
    super.key,
    required this.shopName,
    required this.businessType,
    required this.isOpen,
    required this.onShopTap,
    required this.onShopChanged,
    required this.onTab,
    required this.onEarnings,
  });
  final String shopName, businessType;
  final bool isOpen;
  final VoidCallback onShopTap, onEarnings;
  final ValueChanged<bool> onShopChanged;
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
              color: SellerColors.raised,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Image.asset('assets/images/alpha_cart_logo.png'),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Alpha Cart  /  Seller',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
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
      Text(
        'Hi, $shopName 👋',
        style: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w800,
          letterSpacing: -.5,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        businessType,
        style: const TextStyle(color: SellerColors.muted, fontSize: 12),
      ),
      const SizedBox(height: 18),
      InkWell(
        onTap: onShopTap,
        borderRadius: BorderRadius.circular(21),
        child: SellerClay(
          color: isOpen ? const Color(0xFF12351F) : const Color(0xFF35191A),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  isOpen ? Icons.storefront_rounded : Icons.storefront_outlined,
                  color: isOpen ? SellerColors.green : SellerColors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOpen ? 'Shop is open' : 'Shop is closed',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isOpen
                          ? 'You’re live and can receive orders'
                          : 'Turn on to start receiving orders',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isOpen,
                onChanged: onShopChanged,
                activeColor: SellerColors.green,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 17),
      const Row(
        children: [
          Expanded(
            child: ZeroMetric(
              title: 'Orders today',
              value: '0',
              icon: Icons.shopping_bag_outlined,
              tint: Color(0xFF173F2B),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ZeroMetric(
              title: 'Sales today',
              value: '₹0',
              icon: Icons.currency_rupee,
              tint: Color(0xFF291C3F),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onEarnings,
              borderRadius: BorderRadius.circular(22),
              child: const ZeroMetric(
                title: 'Net earnings',
                value: '₹0',
                icon: Icons.account_balance_wallet_outlined,
                tint: Color(0xFF1E3550),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: () => onTab(2),
              borderRadius: BorderRadius.circular(22),
              child: const ZeroMetric(
                title: 'Products',
                value: '3',
                icon: Icons.inventory_2_outlined,
                tint: Color(0xFF3A2916),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 23),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Quick actions',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          TextButton(
            onPressed: onShopTap,
            child: const Text(
              'Shop settings',
              style: TextStyle(color: SellerColors.orange, fontSize: 11),
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
        childAspectRatio: .98,
        children: [
          SellerShortcut(
            icon: Icons.receipt_long,
            label: 'Orders',
            onTap: () => onTab(1),
          ),
          SellerShortcut(
            icon: Icons.inventory_2_outlined,
            label: 'Products',
            onTap: () => onTab(2),
          ),
          SellerShortcut(
            icon: Icons.payments_outlined,
            label: 'Earnings',
            onTap: onEarnings,
          ),
          SellerShortcut(
            icon: Icons.bar_chart,
            label: 'Reports',
            onTap: () => onTab(3),
          ),
          SellerShortcut(
            icon: Icons.schedule,
            label: 'Shop hours',
            onTap: onShopTap,
          ),
          SellerShortcut(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () => _settings(context),
          ),
        ],
      ),
      const SizedBox(height: 20),
      InkWell(
        onTap: () => onTab(3),
        borderRadius: BorderRadius.circular(20),
        child: SellerClay(
          color: const Color(0xFF2A1D30),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFF54366B),
                child: Icon(
                  Icons.campaign_outlined,
                  color: SellerColors.lavender,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Boost your sales',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Explore offers and business reports',
                      style: TextStyle(color: SellerColors.muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: SellerColors.lavender,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      const Text(
        'Recent orders',
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
      ),
      const SizedBox(height: 11),
      const SellerEmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No orders yet',
        detail: 'New orders will appear here as soon as customers place them.',
      ),
    ],
  );

  void _settings(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    backgroundColor: SellerColors.screen,
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shop settings',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(
                Icons.storefront_outlined,
                color: SellerColors.orange,
              ),
              title: const Text('Shop profile'),
              subtitle: Text('$shopName · $businessType'),
              onTap: () => Navigator.pop(context),
            ),
            const ListTile(
              leading: Icon(Icons.help_outline, color: SellerColors.orange),
              title: Text('Help & support'),
              subtitle: Text('Get help with your seller account'),
            ),
          ],
        ),
      ),
    ),
  );
}

class SellerShortcut extends StatelessWidget {
  const SellerShortcut({
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
    child: SellerClay(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: SellerColors.orange, size: 22),
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

class SellerOrdersPage extends StatelessWidget {
  const SellerOrdersPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
    children: [
      const SellerHeader(
        title: 'Orders',
        subtitle: 'Manage incoming and active orders',
      ),
      const SizedBox(height: 19),
      const _OrderFilters(),
      const SizedBox(height: 15),
      const SellerEmptyState(
        icon: Icons.shopping_bag_outlined,
        title: 'No orders yet',
        detail: 'When a customer places an order, you can review it and accept it here.',
      ),
    ],
  );
}

class _OrderFilters extends StatefulWidget {
  const _OrderFilters();
  @override
  State<_OrderFilters> createState() => _OrderFiltersState();
}

class _OrderFiltersState extends State<_OrderFilters> {
  int selected = 0;
  final labels = const ['New (0)', 'Preparing (0)', 'Ready (0)'];
  @override
  Widget build(BuildContext context) => Row(
    children: List.generate(
      labels.length,
      (i) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: i == 2 ? 0 : 7),
          child: InkWell(
            onTap: () => setState(() => selected = i),
            borderRadius: BorderRadius.circular(13),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: selected == i
                    ? SellerColors.orange
                    : SellerColors.raised,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: selected == i
                      ? SellerColors.orange
                      : SellerColors.line,
                ),
              ),
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: selected == i ? Colors.white : SellerColors.muted,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class SellerProductsPage extends StatefulWidget {
  const SellerProductsPage({
    super.key,
    required this.products,
    required this.onAdd,
    required this.onChanged,
  });
  final List<SellerProduct> products;
  final VoidCallback onAdd, onChanged;
  @override
  State<SellerProductsPage> createState() => _SellerProductsPageState();
}

class _SellerProductsPageState extends State<SellerProductsPage> {
  String _query = '';
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final visibleProducts = widget.products.where((product) {
      final queryMatches = product.name.toLowerCase().contains(
        _query.toLowerCase(),
      );
      final filterMatches =
          _filter == 'All' ||
          (_filter == 'Available' ? product.available : !product.available);
      return queryMatches && filterMatches;
    }).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
      children: [
        Row(
          children: [
            const Expanded(
              child: SellerHeader(
                title: 'My products',
                subtitle: 'Keep your catalogue up to date',
              ),
            ),
            IconButton(
              onPressed: widget.onAdd,
              icon: const Icon(
                Icons.add_circle,
                color: SellerColors.orange,
                size: 29,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        TextField(
          onChanged: (value) => setState(() => _query = value.trim()),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search your products',
          ),
        ),
        const SizedBox(height: 13),
        Row(
          children: [
            Expanded(
              child: _ProductCountChip(
                label: 'All',
                count: widget.products.length,
                selected: _filter == 'All',
                onTap: () => setState(() => _filter = 'All'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ProductCountChip(
                label: 'Available',
                count: widget.products.where((p) => p.available).length,
                selected: _filter == 'Available',
                onTap: () => setState(() => _filter = 'Available'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ProductCountChip(
                label: 'Out of stock',
                count: widget.products.where((p) => !p.available).length,
                selected: _filter == 'Out of stock',
                onTap: () => setState(() => _filter = 'Out of stock'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),
        ...visibleProducts.map(
          (product) =>
              _ProductTile(product: product, onChanged: widget.onChanged),
        ),
        if (visibleProducts.isEmpty)
          const SellerEmptyState(
            icon: Icons.search_off_rounded,
            title: 'No matching products',
            detail: 'Try another search or add a product to your catalogue.',
          ),
        const SizedBox(height: 7),
        SellerButton(
          label: 'Add new item',
          icon: Icons.add,
          onPressed: widget.onAdd,
        ),
      ],
    );
  }
}

class _ProductCountChip extends StatelessWidget {
  const _ProductCountChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: SellerClay(
      color: selected ? const Color(0xFF36200F) : SellerColors.card,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
      child: Text(
        '$label ($count)',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

class _ProductTile extends StatefulWidget {
  const _ProductTile({required this.product, required this.onChanged});
  final SellerProduct product;
  final VoidCallback onChanged;
  @override
  State<_ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<_ProductTile> {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: SellerClay(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: SellerColors.raised,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              color: SellerColors.orange,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.product.category,
                  style: const TextStyle(
                    color: SellerColors.muted,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${widget.product.price}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: widget.product.available,
            onChanged: (value) {
              setState(() => widget.product.available = value);
              widget.onChanged();
            },
            activeColor: SellerColors.green,
          ),
        ],
      ),
    ),
  );
}

class AddProductSheet extends StatefulWidget {
  const AddProductSheet({super.key});
  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final _name = TextEditingController();
  final _price = TextEditingController(text: '0');
  String _category = 'Food';
  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      22,
      20,
      MediaQuery.viewInsetsOf(context).bottom + 20,
    ),
    child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Add a product',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: 'Product name',
              hintText: 'e.g. Chicken Biryani',
            ),
          ),
          const SizedBox(height: 11),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Category'),
            items: const [
              'Food',
              'Grocery',
              'Gym & Fitness',
              'Use & Throw',
            ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (v) => setState(() => _category = v ?? 'Food'),
          ),
          const SizedBox(height: 11),
          TextField(
            controller: _price,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Price',
              prefixText: '₹',
              hintText: '0',
            ),
          ),
          const SizedBox(height: 17),
          SellerButton(
            label: 'Save product',
            icon: Icons.check,
            onPressed: () {
              if (_name.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter a product name.')),
                );
                return;
              }
              Navigator.pop(
                context,
                SellerProduct(
                  name: _name.text.trim(),
                  category: _category,
                  price: int.tryParse(_price.text.trim()) ?? 0,
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

class ShopStatusPage extends StatefulWidget {
  const ShopStatusPage({super.key, required this.initiallyOpen});
  final bool initiallyOpen;
  @override
  State<ShopStatusPage> createState() => _ShopStatusPageState();
}

class _ShopStatusPageState extends State<ShopStatusPage> {
  late bool _open = widget.initiallyOpen;
  bool _breakTime = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('Shop status'),
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SellerClay(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const Icon(
                Icons.storefront_rounded,
                size: 68,
                color: SellerColors.orange,
              ),
              const SizedBox(height: 13),
              const Text(
                'Your shop is',
                style: TextStyle(color: SellerColors.muted),
              ),
              Text(
                _open ? 'OPEN' : 'CLOSED',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: _open ? SellerColors.green : SellerColors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SellerClay(
          color: _open ? const Color(0xFF12351F) : const Color(0xFF35191A),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _open ? 'Shop open' : 'Shop closed',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Switch(
                value: _open,
                onChanged: (v) => setState(() => _open = v),
                activeColor: SellerColors.green,
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        const Text(
          'Set your regular hours',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 9),
        const Row(
          children: [
            Expanded(
              child: _TimeTile(title: 'Opening time', time: '09:00 AM'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _TimeTile(title: 'Closing time', time: '11:00 PM'),
            ),
          ],
        ),
        const SizedBox(height: 11),
        SellerClay(
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Break time',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Switch(
                value: _breakTime,
                onChanged: (v) => setState(() => _breakTime = v),
                activeColor: SellerColors.orange,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        SellerButton(
          label: 'Save changes',
          icon: Icons.check,
          onPressed: () => Navigator.pop(context, _open),
        ),
      ],
    ),
  );
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({required this.title, required this.time});
  final String title, time;
  @override
  Widget build(BuildContext context) => SellerClay(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: SellerColors.muted, fontSize: 10),
        ),
        const SizedBox(height: 7),
        Text(
          time,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ],
    ),
  );
}

class SellerEarningsPage extends StatelessWidget {
  const SellerEarningsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('Earnings'),
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const _EarningsRange(),
        const SizedBox(height: 14),
        const SellerClay(
          color: Color(0xFF17211D),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total earnings',
                style: TextStyle(color: SellerColors.muted, fontSize: 12),
              ),
              SizedBox(height: 8),
              Text(
                '₹0',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 5),
              Text(
                '0% from yesterday',
                style: TextStyle(color: SellerColors.green, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const SellerClay(
          child: Column(
            children: [
              SellerValueRow(label: 'Orders completed', value: '0'),
              SellerValueRow(label: 'Sales value', value: '₹0'),
              SellerValueRow(label: 'Commission (0%)', value: '₹0'),
              Divider(color: SellerColors.line),
              SellerValueRow(
                label: 'Net earnings',
                value: '₹0',
                emphasized: true,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _EarningsRange extends StatefulWidget {
  const _EarningsRange();
  @override
  State<_EarningsRange> createState() => _EarningsRangeState();
}

class _EarningsRangeState extends State<_EarningsRange> {
  String range = 'Today';
  @override
  Widget build(BuildContext context) => Row(
    children: ['Today', 'This week', 'This month']
        .map(
          (v) => Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 7),
              child: InkWell(
                onTap: () => setState(() => range = v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: range == v
                        ? SellerColors.orange
                        : SellerColors.raised,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: range == v
                          ? SellerColors.orange
                          : SellerColors.line,
                    ),
                  ),
                  child: Text(
                    v,
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

class SellerValueRow extends StatelessWidget {
  const SellerValueRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasized = false,
  });
  final String label, value;
  final bool emphasized;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: emphasized ? Colors.white : SellerColors.muted,
              fontSize: 12,
              fontWeight: emphasized ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: emphasized ? SellerColors.orange : Colors.white,
          ),
        ),
      ],
    ),
  );
}

class SellerReportsPage extends StatelessWidget {
  const SellerReportsPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
    children: [
      const SellerHeader(
        title: 'Business reports',
        subtitle: 'A clear view of your shop performance',
      ),
      const SizedBox(height: 17),
      const _ReportPeriod(),
      const SizedBox(height: 14),
      const SellerClay(
        padding: EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales overview',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
            SizedBox(height: 7),
            Text(
              '₹0',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
            ),
            SizedBox(height: 16),
            _ZeroBars(),
            SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mon',
                  style: TextStyle(color: SellerColors.muted, fontSize: 9),
                ),
                Text(
                  'Tue',
                  style: TextStyle(color: SellerColors.muted, fontSize: 9),
                ),
                Text(
                  'Wed',
                  style: TextStyle(color: SellerColors.muted, fontSize: 9),
                ),
                Text(
                  'Thu',
                  style: TextStyle(color: SellerColors.muted, fontSize: 9),
                ),
                Text(
                  'Fri',
                  style: TextStyle(color: SellerColors.muted, fontSize: 9),
                ),
                Text(
                  'Sat',
                  style: TextStyle(color: SellerColors.muted, fontSize: 9),
                ),
                Text(
                  'Sun',
                  style: TextStyle(color: SellerColors.muted, fontSize: 9),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      const SellerClay(
        child: Column(
          children: [
            SellerValueRow(label: 'Total orders', value: '0'),
            SellerValueRow(label: 'Total sales', value: '₹0'),
            SellerValueRow(label: 'Commission', value: '₹0'),
            SellerValueRow(
              label: 'Net earnings',
              value: '₹0',
              emphasized: true,
            ),
          ],
        ),
      ),
    ],
  );
}

class _ReportPeriod extends StatefulWidget {
  const _ReportPeriod();
  @override
  State<_ReportPeriod> createState() => _ReportPeriodState();
}

class _ReportPeriodState extends State<_ReportPeriod> {
  String period = 'Last 7 days';
  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    initialValue: period,
    decoration: const InputDecoration(
      prefixIcon: Icon(Icons.calendar_today_outlined, size: 18),
    ),
    items: const [
      'Today',
      'Last 7 days',
      'This month',
    ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
    onChanged: (v) => setState(() => period = v ?? period),
  );
}

class _ZeroBars extends StatelessWidget {
  const _ZeroBars();
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 112,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        7,
        (_) => Container(
          width: 22,
          height: 4,
          decoration: BoxDecoration(
            color: SellerColors.orange,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: SellerColors.orange.withValues(alpha: .3),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
