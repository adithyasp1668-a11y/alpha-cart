import 'package:flutter/material.dart';

import '../models/customer_product.dart';
import '../theme/customer_theme.dart';
import '../widgets/customer_widgets.dart';

class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key, required this.location});
  final String location;
  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int _tab = 0;
  int _ordersPlaced = 0;
  int _orderCounter = 784326;
  late String _location;
  final Map<String, int> _cart = {};
  final Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    _location = widget.location;
  }

  int _quantity(CustomerProduct product) => _cart[product.id] ?? 0;
  void _add(CustomerProduct product) =>
      setState(() => _cart.update(product.id, (n) => n + 1, ifAbsent: () => 1));
  void _changeQuantity(CustomerProduct product, int delta) => setState(() {
    final next = _quantity(product) + delta;
    if (next <= 0) {
      _cart.remove(product.id);
    } else {
      _cart[product.id] = next;
    }
  });
  int get _itemCount => _cart.values.fold(0, (sum, value) => sum + value);
  int get _subtotal => customerProducts.fold(
    0,
    (sum, product) => sum + product.price * _quantity(product),
  );

  Future<void> _checkout() async {
    if (_cart.isEmpty) return;
    final orderId = 'AC$_orderCounter';
    final placed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(
          items: Map.of(_cart),
          location: _location,
          total:
              _subtotal +
              (_subtotal == 0 ? 0 : 40) -
              (_subtotal >= 500 ? 100 : 0),
          orderId: orderId,
        ),
      ),
    );
    if (placed == true && mounted)
      setState(() {
        _ordersPlaced += 1;
        _orderCounter += 1;
        _cart.clear();
        _tab = 3;
      });
  }

  void _openProduct(CustomerProduct product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsPage(
          product: product,
          quantity: _quantity(product),
          onAdd: () {
            _add(product);
            Navigator.pop(context);
          },
          isFavorite: _favorites.contains(product.id),
          onFavorite: () => setState(() {
            if (!_favorites.add(product.id)) _favorites.remove(product.id);
          }),
        ),
      ),
    );
  }

  void _openCategory(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryProductsPage(
          category: category,
          quantities: _cart,
          onAdd: _add,
          onOpen: _openProduct,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      CustomerHomePage(
        location: _location,
        itemCount: _itemCount,
        quantities: _cart,
        onCategory: _openCategory,
        onAdd: _add,
        onOpen: _openProduct,
        onCart: () => setState(() => _tab = 2),
        onSearch: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchPage(
              quantities: _cart,
              onAdd: _add,
              onOpen: _openProduct,
            ),
          ),
        ),
        onLocationChanged: (value) => setState(() => _location = value),
      ),
      AllCategoriesPage(onSelect: _openCategory),
      CartPage(
        items: _cart,
        onChange: _changeQuantity,
        onBrowse: () => setState(() => _tab = 1),
        onCheckout: _checkout,
      ),
      OrdersPage(ordersPlaced: _ordersPlaced, orderCounter: _orderCounter),
      ProfilePage(
        location: _location,
        onWishlist: _openWishlist,
        onOrders: () => setState(() => _tab = 3),
      ),
    ];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF101613), CustomerColors.base, Color(0xFF15100D)],
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
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
        onDestinationSelected: (v) => setState(() => _tab = v),
        backgroundColor: CustomerColors.screen,
        indicatorColor: CustomerColors.orange.withValues(alpha: .16),
        height: 70,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _itemCount > 0,
              label: Text('$_itemCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            selectedIcon: const Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _openWishlist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WishlistPage(
          favorites: customerProducts
              .where((p) => _favorites.contains(p.id))
              .toList(),
          quantities: _cart,
          onAdd: _add,
          onOpen: _openProduct,
        ),
      ),
    );
  }
}

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({
    super.key,
    required this.location,
    required this.itemCount,
    required this.quantities,
    required this.onCategory,
    required this.onAdd,
    required this.onOpen,
    required this.onCart,
    required this.onSearch,
    required this.onLocationChanged,
  });
  final String location;
  final int itemCount;
  final Map<String, int> quantities;
  final ValueChanged<String> onCategory;
  final ValueChanged<CustomerProduct> onAdd, onOpen;
  final VoidCallback onCart, onSearch;
  final ValueChanged<String> onLocationChanged;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(17, 10, 17, 26),
    children: [
      Row(
        children: [
          Container(
            width: 38,
            height: 38,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: CustomerColors.raised,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Image.asset('assets/images/alpha_cart_logo.png'),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: InkWell(
              onTap: () => _changeLocation(context, onLocationChanged),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deliver to',
                    style: TextStyle(color: CustomerColors.muted, fontSize: 9),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          location,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: CustomerColors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onSearch,
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            onPressed: onCart,
            icon: Badge(
              isLabelVisible: itemCount > 0,
              label: Text('$itemCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
      ),
      const SizedBox(height: 13),
      InkWell(
        onTap: onSearch,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: CustomerColors.raised,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: CustomerColors.line),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: CustomerColors.muted, size: 18),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Search groceries, food, fitness...',
                  style: TextStyle(color: CustomerColors.muted, fontSize: 11),
                ),
              ),
              Icon(Icons.tune_rounded, color: CustomerColors.orange, size: 18),
            ],
          ),
        ),
      ),
      const SizedBox(height: 14),
      InkWell(
        onTap: () => onCategory('Grocery'),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 122,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF633B83), Color(0xFF351A52)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: CustomerColors.purple.withValues(alpha: .19),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'UP TO 40% OFF',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .7,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      'On your first order',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Fresh picks, delivered fast',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ),
              const Text('🥬', style: TextStyle(fontSize: 62)),
            ],
          ),
        ),
      ),
      const SizedBox(height: 18),
      Row(
        children: customerCategories
            .map(
              (category) => Expanded(
                child: InkWell(
                  onTap: () => onCategory(category.name),
                  child: Column(
                    children: [
                      Container(
                        width: 53,
                        height: 53,
                        decoration: BoxDecoration(
                          color: category.color.withValues(alpha: .18),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Center(
                          child: Text(
                            category.emoji,
                            style: const TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category.name.split(' ').first,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 20),
      CustomerSectionTitle(
        title: 'Shop by category',
        action: 'View all',
        onTap: () => onCategory('All'),
      ),
      const SizedBox(height: 9),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.9,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: customerCategories
            .map(
              (c) => CustomerCategoryCard(
                name: c.name,
                subtitle: c.subtitle,
                emoji: c.emoji,
                color: c.color,
                onTap: () => onCategory(c.name),
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 18),
      CustomerSectionTitle(
        title: 'Popular near you',
        action: 'See all',
        onTap: () => onCategory('Food'),
      ),
      const SizedBox(height: 9),
      const MerchantCard(
        name: 'The Spice Haven',
        category: 'Restaurant · BTM Layout',
        rating: '4.6',
        eta: '20–30 min',
        emoji: '🍛',
      ),
      const SizedBox(height: 9),
      const MerchantCard(
        name: 'Biryani House',
        category: 'Restaurant · HSR Layout',
        rating: '4.5',
        eta: '25–35 min',
        emoji: '🍲',
      ),
      const SizedBox(height: 18),
      CustomerSectionTitle(
        title: 'Fresh picks for you',
        action: 'Explore',
        onTap: () => onCategory('Grocery'),
      ),
      const SizedBox(height: 9),
      SizedBox(
        height: 190,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: customerProducts
              .take(4)
              .map(
                (p) => SizedBox(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CustomerProductCard(
                      product: p,
                      quantity: quantities[p.id] ?? 0,
                      onAdd: () => onAdd(p),
                      onTap: () => onOpen(p),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    ],
  );
  void _changeLocation(
    BuildContext context,
    ValueChanged<String> onLocationChanged,
  ) {
    final controller = TextEditingController(text: location);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CustomerColors.card,
        title: const Text('Delivery location'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Area, city'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final nextLocation = controller.text.trim();
              if (nextLocation.isEmpty) return;
              Navigator.pop(ctx);
              onLocationChanged(nextLocation);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Location set to $nextLocation')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class MerchantCard extends StatelessWidget {
  const MerchantCard({
    super.key,
    required this.name,
    required this.category,
    required this.rating,
    required this.eta,
    required this.emoji,
  });
  final String name, category, rating, eta, emoji;
  @override
  Widget build(BuildContext context) => CustomerClay(
    padding: const EdgeInsets.all(11),
    child: Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: CustomerColors.raised,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 29)),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category,
                style: const TextStyle(
                  color: CustomerColors.muted,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 11,
                    color: CustomerColors.yellow,
                  ),
                  Text(
                    ' $rating  ·  $eta',
                    style: const TextStyle(
                      fontSize: 9,
                      color: CustomerColors.muted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.favorite_border,
            color: CustomerColors.muted,
            size: 18,
          ),
        ),
      ],
    ),
  );
}

class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({super.key, required this.onSelect});
  final ValueChanged<String> onSelect;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(18, 16, 18, 26),
    children: [
      const Text(
        'Categories',
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
      ),
      const SizedBox(height: 5),
      const Text(
        'Explore everything you need',
        style: TextStyle(color: CustomerColors.muted, fontSize: 12),
      ),
      const SizedBox(height: 17),
      ...customerCategories.map(
        (category) => Padding(
          padding: const EdgeInsets.only(bottom: 11),
          child: InkWell(
            onTap: () => onSelect(category.name),
            borderRadius: BorderRadius.circular(20),
            child: CustomerClay(
              color: category.color.withValues(alpha: .18),
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Text(category.emoji, style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category.subtitle,
                          style: const TextStyle(
                            color: CustomerColors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: CustomerColors.muted),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class CategoryProductsPage extends StatefulWidget {
  const CategoryProductsPage({
    super.key,
    required this.category,
    required this.quantities,
    required this.onAdd,
    required this.onOpen,
  });
  final String category;
  final Map<String, int> quantities;
  final ValueChanged<CustomerProduct> onAdd, onOpen;
  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  String _chip = 'All';
  @override
  Widget build(BuildContext context) {
    final products = customerProducts
        .where((p) => widget.category == 'All' || p.category == widget.category)
        .toList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(widget.category == 'All' ? 'Categories' : widget.category),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SearchPage(
                  quantities: widget.quantities,
                  onAdd: widget.onAdd,
                  onOpen: widget.onOpen,
                ),
              ),
            ),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          if (widget.category == 'Grocery' || widget.category == 'Food')
            SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                children:
                    (widget.category == 'Grocery'
                            ? ['All', 'Fruits & Veg', 'Dairy', 'Snacks']
                            : ['All', 'Veg', 'Non-Veg'])
                        .map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(c),
                              selected: _chip == c,
                              onSelected: (_) => setState(() => _chip = c),
                              selectedColor: CustomerColors.orange,
                              backgroundColor: CustomerColors.raised,
                              side: BorderSide(
                                color: _chip == c
                                    ? CustomerColors.orange
                                    : CustomerColors.line,
                              ),
                              labelStyle: TextStyle(
                                color: _chip == c
                                    ? Colors.white
                                    : CustomerColors.muted,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 11,
                mainAxisSpacing: 11,
                childAspectRatio: .73,
              ),
              itemCount: products.length,
              itemBuilder: (_, i) {
                final p = products[i];
                return CustomerProductCard(
                  product: p,
                  quantity: widget.quantities[p.id] ?? 0,
                  onAdd: () {
                    widget.onAdd(p);
                    setState(() {});
                  },
                  onTap: () => widget.onOpen(p),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdd,
    required this.isFavorite,
    required this.onFavorite,
  });
  final CustomerProduct product;
  final int quantity;
  final VoidCallback onAdd, onFavorite;
  final bool isFavorite;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
          onPressed: onFavorite,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: CustomerColors.orange,
          ),
        ),
      ],
    ),
    body: Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              CustomerClay(
                padding: const EdgeInsets.all(25),
                child: SizedBox(
                  height: 210,
                  child: Center(
                    child: Text(
                      product.emoji,
                      style: const TextStyle(fontSize: 112),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Text(
                    '₹${product.price}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (product.oldPrice != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      '₹${product.oldPrice}',
                      style: const TextStyle(
                        color: CustomerColors.muted,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                  const Spacer(),
                  const Icon(
                    Icons.star,
                    size: 15,
                    color: CustomerColors.yellow,
                  ),
                  const Text(
                    ' 4.7 (128)',
                    style: TextStyle(color: CustomerColors.muted, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                product.description,
                style: const TextStyle(
                  color: CustomerColors.muted,
                  height: 1.5,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 18),
              const CustomerClay(
                child: Row(
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      color: CustomerColors.orange,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available near you',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Local partner · 20–30 min',
                            style: TextStyle(
                              color: CustomerColors.muted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
          child: CustomerButton(
            label: quantity > 0
                ? 'Add another · ₹${product.price}'
                : 'Add to cart · ₹${product.price}',
            icon: Icons.add_shopping_cart,
            onPressed: onAdd,
          ),
        ),
      ],
    ),
  );
}

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.quantities,
    required this.onAdd,
    required this.onOpen,
  });
  final Map<String, int> quantities;
  final ValueChanged<CustomerProduct> onAdd, onOpen;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  String category = 'All';
  @override
  Widget build(BuildContext context) {
    final results = customerProducts
        .where(
          (p) =>
              (category == 'All' || p.category == category) &&
              (query.isEmpty ||
                  p.name.toLowerCase().contains(query.toLowerCase())),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: TextField(
          autofocus: true,
          onChanged: (v) => setState(() => query = v),
          decoration: const InputDecoration(
            hintText: 'Search products and stores',
            border: InputBorder.none,
            filled: false,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              children:
                  ['All', 'Grocery', 'Food', 'Gym & Fitness', 'Use & Throw']
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: ChoiceChip(
                            label: Text(c),
                            selected: category == c,
                            onSelected: (_) => setState(() => category = c),
                            selectedColor: CustomerColors.orange,
                            backgroundColor: CustomerColors.raised,
                            side: BorderSide(
                              color: category == c
                                  ? CustomerColors.orange
                                  : CustomerColors.line,
                            ),
                            labelStyle: const TextStyle(fontSize: 9),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .73,
              ),
              itemCount: results.length,
              itemBuilder: (_, i) {
                final p = results[i];
                return CustomerProductCard(
                  product: p,
                  quantity: widget.quantities[p.id] ?? 0,
                  onAdd: () => widget.onAdd(p),
                  onTap: () => widget.onOpen(p),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({
    super.key,
    required this.items,
    required this.onChange,
    required this.onBrowse,
    required this.onCheckout,
  });
  final Map<String, int> items;
  final void Function(CustomerProduct, int) onChange;
  final VoidCallback onBrowse, onCheckout;
  @override
  Widget build(BuildContext context) {
    final products = customerProducts
        .where((p) => (items[p.id] ?? 0) > 0)
        .toList();
    final subtotal = products.fold<int>(
      0,
      (sum, product) => sum + product.price * (items[product.id] ?? 0),
    );
    final discount = subtotal >= 500 ? 100 : 0;
    final delivery = subtotal == 0 ? 0 : 40;
    final total = subtotal + delivery - discount;
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 27),
      children: [
        const Text(
          'My cart',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
        ),
        Text(
          '${items.values.fold(0, (a, b) => a + b)} items',
          style: const TextStyle(color: CustomerColors.muted, fontSize: 11),
        ),
        const SizedBox(height: 15),
        if (products.isEmpty)
          CustomerEmptyState(
            icon: Icons.shopping_bag_outlined,
            title: 'Your cart is waiting',
            subtitle: 'Add something you love and it will show up here.',
            action: CustomerButton(
              label: 'Browse categories',
              icon: Icons.grid_view_rounded,
              onPressed: onBrowse,
            ),
          )
        else
          ...products.map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: CartProductRow(
                product: product,
                quantity: items[product.id] ?? 0,
                onChange: onChange,
              ),
            ),
          ),
        if (products.isNotEmpty) ...[
          const SizedBox(height: 5),
          CustomerClay(
            child: Column(
              children: [
                CustomerValueRow(label: 'Item total', value: '₹$subtotal'),
                CustomerValueRow(label: 'Delivery fee', value: '₹$delivery'),
                CustomerValueRow(label: 'Discount', value: '-₹$discount'),
                const Divider(color: CustomerColors.line),
                CustomerValueRow(
                  label: 'To pay',
                  value: '₹$total',
                  strong: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          CustomerClay(
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: CustomerColors.orange,
                ),
                const SizedBox(width: 9),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery address',
                        style: TextStyle(
                          color: CustomerColors.muted,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        'Home · BTM Layout, Bengaluru',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _selectAddress(context),
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      color: CustomerColors.orange,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          CustomerButton(
            label: 'Proceed to checkout · ₹$total',
            icon: Icons.arrow_forward_rounded,
            onPressed: onCheckout,
          ),
        ],
      ],
    );
  }

  Future<void> _selectAddress(
    BuildContext context,
  ) => showModalBottomSheet<void>(
    context: context,
    backgroundColor: CustomerColors.screen,
    builder: (_) => const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose delivery address',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.home_outlined, color: CustomerColors.orange),
              title: Text('Home'),
              subtitle: Text('123, 4th Cross, BTM Layout, Bengaluru'),
            ),
            ListTile(
              leading: Icon(Icons.work_outline, color: CustomerColors.orange),
              title: Text('Work'),
              subtitle: Text('Alpha Tech Park, Hosur Road'),
            ),
          ],
        ),
      ),
    ),
  );
}

class CartProductRow extends StatelessWidget {
  const CartProductRow({
    super.key,
    required this.product,
    required this.quantity,
    required this.onChange,
  });
  final CustomerProduct product;
  final int quantity;
  final void Function(CustomerProduct, int) onChange;
  @override
  Widget build(BuildContext context) => CustomerClay(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
    child: Row(
      children: [
        Container(
          width: 49,
          height: 49,
          decoration: BoxDecoration(
            color: CustomerColors.raised,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(product.emoji, style: const TextStyle(fontSize: 27)),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '₹${product.price}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: CustomerColors.raised,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CustomerColors.line),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => onChange(product, -1),
                icon: const Icon(Icons.remove, size: 14),
                constraints: const BoxConstraints.tightFor(
                  width: 30,
                  height: 32,
                ),
                padding: EdgeInsets.zero,
              ),
              Text(
                '$quantity',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
              IconButton(
                onPressed: () => onChange(product, 1),
                icon: const Icon(Icons.add, size: 14),
                constraints: const BoxConstraints.tightFor(
                  width: 30,
                  height: 32,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class CustomerValueRow extends StatelessWidget {
  const CustomerValueRow({
    super.key,
    required this.label,
    required this.value,
    this.strong = false,
  });
  final String label, value;
  final bool strong;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: strong ? Colors.white : CustomerColors.muted,
              fontSize: 11,
              fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: strong ? CustomerColors.orange : Colors.white,
          ),
        ),
      ],
    ),
  );
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    super.key,
    required this.items,
    required this.location,
    required this.total,
    required this.orderId,
  });
  final Map<String, int> items;
  final String location, orderId;
  final int total;
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _address = 'Home';
  String _payment = 'UPI';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('Checkout'),
    ),
    body: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Delivery address',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const SizedBox(height: 10),
        ...['Home', 'Work', 'Add new address'].map(
          (address) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => setState(() => _address = address),
              child: CustomerClay(
                child: Row(
                  children: [
                    Icon(
                      address == 'Home'
                          ? Icons.home_outlined
                          : address == 'Work'
                          ? Icons.work_outline
                          : Icons.add_location_alt_outlined,
                      color: CustomerColors.orange,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            address == 'Home'
                                ? '${widget.location} · Bengaluru'
                                : address == 'Work'
                                ? 'Alpha Tech Park, Bengaluru'
                                : 'Add a delivery location',
                            style: const TextStyle(
                              color: CustomerColors.muted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _address == address
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: _address == address
                          ? CustomerColors.orange
                          : CustomerColors.muted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 13),
        const Text(
          'Payment method',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const SizedBox(height: 10),
        ...[
          'UPI',
          'Credit / Debit Card',
          'Net Banking',
          'Wallet',
          'Cash on Delivery',
        ].map(
          (method) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => setState(() => _payment = method),
              child: CustomerClay(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                child: Row(
                  children: [
                    Icon(
                      method == 'UPI'
                          ? Icons.qr_code_2
                          : method == 'Cash on Delivery'
                          ? Icons.payments_outlined
                          : Icons.credit_card,
                      color: CustomerColors.orange,
                      size: 19,
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        method,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Icon(
                      _payment == method
                          ? Icons.check_circle
                          : Icons.chevron_right,
                      color: _payment == method
                          ? CustomerColors.orange
                          : CustomerColors.muted,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        CustomerClay(
          child: CustomerValueRow(
            label: 'To pay',
            value: '₹${widget.total}',
            strong: true,
          ),
        ),
        const SizedBox(height: 14),
        CustomerButton(
          label: 'Place order · ₹${widget.total}',
          icon: Icons.lock_outline,
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OrderSuccessPage(
                orderId: widget.orderId,
                total: widget.total,
                payment: _payment,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({
    super.key,
    required this.orderId,
    required this.total,
    required this.payment,
  });
  final String orderId, payment;
  final int total;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 39,
                backgroundColor: Color(0xFF1B4B28),
                child: Icon(
                  Icons.check_rounded,
                  color: CustomerColors.green,
                  size: 43,
                ),
              ),
              const SizedBox(height: 19),
              const Text(
                'Order placed\nsuccessfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 11),
              Text(
                'Order ID: $orderId',
                style: const TextStyle(
                  color: CustomerColors.muted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '₹$total · $payment',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 25),
              CustomerButton(
                label: 'Track order',
                icon: Icons.location_searching,
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TrackingPage(orderId: orderId, total: total),
                  ),
                ),
              ),
              const SizedBox(height: 9),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Continue shopping',
                  style: TextStyle(color: CustomerColors.muted),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key, required this.orderId, required this.total});
  final String orderId;
  final int total;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context, true),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('Track order'),
    ),
    body: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        CustomerClay(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order $orderId',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 5),
              Text(
                '₹$total · Arriving in 25–35 min',
                style: const TextStyle(
                  color: CustomerColors.muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const CustomerClay(
          padding: EdgeInsets.all(17),
          child: Column(
            children: [
              TrackingStep(
                title: 'Order confirmed',
                time: 'Just now',
                complete: true,
              ),
              TrackingStep(
                title: 'Preparing your order',
                time: 'Next',
                complete: false,
              ),
              TrackingStep(
                title: 'Picked up by delivery partner',
                time: '',
                complete: false,
              ),
              TrackingStep(title: 'On the way', time: '', complete: false),
              TrackingStep(title: 'Delivered', time: '', complete: false),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const CustomerClay(
          child: Row(
            children: [
              Icon(Icons.delivery_dining, color: CustomerColors.orange),
              SizedBox(width: 11),
              Expanded(
                child: Text(
                  'Delivery partner details will appear when your order is picked up.',
                  style: TextStyle(
                    color: CustomerColors.muted,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class TrackingStep extends StatelessWidget {
  const TrackingStep({
    super.key,
    required this.title,
    required this.time,
    required this.complete,
  });
  final String title, time;
  final bool complete;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(
          complete ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 18,
          color: complete ? CustomerColors.green : CustomerColors.muted,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: complete ? FontWeight.w700 : FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ),
        Text(
          time,
          style: const TextStyle(color: CustomerColors.muted, fontSize: 9),
        ),
      ],
    ),
  );
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({
    super.key,
    required this.ordersPlaced,
    required this.orderCounter,
  });
  final int ordersPlaced, orderCounter;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(18, 16, 18, 26),
    children: [
      const Text(
        'My orders',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 12),
      const OrderFilters(),
      const SizedBox(height: 15),
      if (ordersPlaced == 0)
        const CustomerEmptyState(
          icon: Icons.receipt_long_outlined,
          title: 'No orders yet',
          subtitle: 'Your orders will appear here after checkout.',
        )
      else
        ...List.generate(
          ordersPlaced,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CustomerClay(
              child: Row(
                children: [
                  const Text('🍛', style: TextStyle(fontSize: 30)),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #AC${orderCounter - 1 - i}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'The Spice Haven · Confirmed',
                          style: TextStyle(
                            color: CustomerColors.muted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: CustomerColors.muted),
                ],
              ),
            ),
          ),
        ),
    ],
  );
}

class OrderFilters extends StatefulWidget {
  const OrderFilters({super.key});
  @override
  State<OrderFilters> createState() => _OrderFiltersState();
}

class _OrderFiltersState extends State<OrderFilters> {
  String selected = 'All';
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: ['All', 'Ongoing', 'Completed', 'Cancelled']
          .map(
            (v) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(v),
                selected: selected == v,
                onSelected: (_) => setState(() => selected = v),
                selectedColor: CustomerColors.orange,
                backgroundColor: CustomerColors.raised,
                side: BorderSide(
                  color: selected == v
                      ? CustomerColors.orange
                      : CustomerColors.line,
                ),
                labelStyle: const TextStyle(fontSize: 10),
              ),
            ),
          )
          .toList(),
    ),
  );
}

class WishlistPage extends StatelessWidget {
  const WishlistPage({
    super.key,
    required this.favorites,
    required this.quantities,
    required this.onAdd,
    required this.onOpen,
  });
  final List<CustomerProduct> favorites;
  final Map<String, int> quantities;
  final ValueChanged<CustomerProduct> onAdd, onOpen;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('Wishlist'),
    ),
    body: favorites.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(18),
            child: CustomerEmptyState(
              icon: Icons.favorite_border,
              title: 'Your wishlist is empty',
              subtitle: 'Save products you love and find them here.',
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: .73,
            ),
            itemCount: favorites.length,
            itemBuilder: (_, i) {
              final p = favorites[i];
              return CustomerProductCard(
                product: p,
                quantity: quantities[p.id] ?? 0,
                onAdd: () => onAdd(p),
                onTap: () => onOpen(p),
              );
            },
          ),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.location,
    required this.onWishlist,
    required this.onOrders,
  });
  final String location;
  final VoidCallback onWishlist, onOrders;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(18, 16, 18, 27),
    children: [
      const Text(
        'Profile',
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
      ),
      const SizedBox(height: 14),
      CustomerClay(
        child: Row(
          children: [
            const CircleAvatar(
              radius: 29,
              backgroundColor: CustomerColors.raised,
              child: Icon(Icons.person, color: CustomerColors.muted, size: 29),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rahul Kumar',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '+91 98765 43210',
                    style: TextStyle(color: CustomerColors.muted, fontSize: 10),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _info(context, 'Edit profile'),
              icon: const Icon(
                Icons.edit_outlined,
                color: CustomerColors.orange,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      _ProfileRow(
        icon: Icons.location_on_outlined,
        title: 'My addresses',
        subtitle: location,
        onTap: () => _info(context, 'My addresses'),
      ),
      _ProfileRow(
        icon: Icons.receipt_long_outlined,
        title: 'Orders',
        subtitle: 'Order history and tracking',
        onTap: onOrders,
      ),
      _ProfileRow(
        icon: Icons.favorite_border,
        title: 'Wishlist',
        subtitle: 'Your saved products',
        onTap: onWishlist,
      ),
      _ProfileRow(
        icon: Icons.card_membership_outlined,
        title: 'AlphaPass membership',
        subtitle: 'Free delivery and exclusive offers',
        onTap: () => _info(context, 'AlphaPass membership'),
      ),
      _ProfileRow(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Saved payment methods',
        subtitle: 'Manage your payments',
        onTap: () => _info(context, 'Payment methods'),
      ),
      _ProfileRow(
        icon: Icons.help_outline,
        title: 'Help & support',
        subtitle: 'FAQs and feedback',
        onTap: () => _info(context, 'Help & support'),
      ),
      _ProfileRow(
        icon: Icons.settings_outlined,
        title: 'Settings',
        subtitle: 'Notifications, location and privacy',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        ),
      ),
    ],
  );
  Future<void> _info(BuildContext context, String title) =>
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: CustomerColors.screen,
        builder: (_) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'This account feature will be connected to your customer profile.',
                  style: TextStyle(color: CustomerColors.muted),
                ),
              ],
            ),
          ),
        ),
      );
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: InkWell(
      onTap: onTap,
      child: CustomerClay(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
        child: Row(
          children: [
            Icon(icon, color: CustomerColors.orange, size: 20),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: CustomerColors.muted,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: CustomerColors.muted,
            ),
          ],
        ),
      ),
    ),
  );
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final values = [true, true, true];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('Settings'),
    ),
    body: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        for (var i = 0; i < 3; i++)
          CustomerClay(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    ['Notifications', 'Location access', 'Dark mode'][i],
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                Switch(
                  value: values[i],
                  activeColor: CustomerColors.green,
                  onChanged: (v) => setState(() => values[i] = v),
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        const CustomerClay(
          child: CustomerValueRow(label: 'Language', value: 'English'),
        ),
        const SizedBox(height: 10),
        const CustomerClay(
          child: CustomerValueRow(label: 'Privacy policy', value: 'View'),
        ),
        const SizedBox(height: 10),
        const CustomerClay(
          child: CustomerValueRow(label: 'Terms & conditions', value: 'View'),
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            'Alpha Cart  ·  v1.0.0',
            style: TextStyle(color: CustomerColors.muted, fontSize: 10),
          ),
        ),
      ],
    ),
  );
}
