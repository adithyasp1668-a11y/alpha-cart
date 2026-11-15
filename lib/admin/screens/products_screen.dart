import 'package:flutter/material.dart';
import '../models/admin_models.dart';
import '../services/admin_api_service.dart';
import '../theme/admin_theme.dart';
import '../widgets/admin_widgets.dart';
import 'product_edit_screen.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _selectedCategory = 'All';
  String _query = '';
  final _searchController = TextEditingController();

  final _categories = ['All', 'Food', 'Gym & Fitness', 'Use & Throw', 'Grocery'];

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
        final filtered = service.products.where((p) {
          final matchesCat = _selectedCategory == 'All' || p.category == _selectedCategory;
          final matchesQuery = _query.isEmpty ||
              p.name.toLowerCase().contains(_query.toLowerCase()) ||
              p.storeName.toLowerCase().contains(_query.toLowerCase());
          return matchesCat && matchesQuery;
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Global Product Catalogue'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add Product',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProductEditPage()),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
            children: [
              // Search field
              TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v.trim()),
                decoration: InputDecoration(
                  hintText: 'Search products or stores...',
                  prefixIcon: const Icon(Icons.search, color: AdminColors.muted),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AdminColors.muted),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 14),

              // Category filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((c) {
                    final active = _selectedCategory == c;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(c),
                        selected: active,
                        selectedColor: AdminColors.orange,
                        backgroundColor: AdminColors.raised,
                        labelStyle: TextStyle(
                          color: active ? Colors.white : AdminColors.muted,
                          fontWeight: active ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        onSelected: (_) => setState(() => _selectedCategory = c),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filtered.length} products listed',
                    style: const TextStyle(color: AdminColors.muted, fontSize: 13),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProductEditPage()),
                      );
                    },
                    icon: const Icon(Icons.add, size: 16, color: AdminColors.orange),
                    label: const Text('Add Product', style: TextStyle(color: AdminColors.orange)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (filtered.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Column(
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 48, color: AdminColors.muted),
                        const SizedBox(height: 12),
                        const Text('No products match your filter', style: TextStyle(color: AdminColors.muted)),
                      ],
                    ),
                  ),
                )
              else
                ...filtered.map((product) => _productCard(context, product, service)),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AdminColors.orange,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProductEditPage()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
          ),
        );
      },
    );
  }

  Widget _productCard(BuildContext context, AdminProduct product, AdminApiService service) {
    IconData icon;
    switch (product.category) {
      case 'Food':
        icon = Icons.rice_bowl;
        break;
      case 'Gym & Fitness':
        icon = Icons.fitness_center;
        break;
      case 'Use & Throw':
        icon = Icons.coffee;
        break;
      default:
        icon = Icons.local_grocery_store;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ProductEditPage(product: product)),
          );
        },
        borderRadius: BorderRadius.circular(22),
        child: ClayPanel(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AdminColors.orange.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AdminColors.orange),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${product.storeName} · ${product.category}',
                      style: const TextStyle(color: AdminColors.muted, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          product.formattedPrice,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AdminColors.green),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Stock: ${product.stockCount}',
                          style: const TextStyle(color: AdminColors.muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Switch(
                    value: product.isAvailable,
                    activeColor: AdminColors.green,
                    onChanged: (_) => service.toggleProductAvailability(product.id),
                  ),
                  Text(
                    product.isAvailable ? 'Active' : 'Hidden',
                    style: TextStyle(
                      fontSize: 10,
                      color: product.isAvailable ? AdminColors.green : AdminColors.muted,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
