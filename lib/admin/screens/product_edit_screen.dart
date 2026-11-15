import 'package:flutter/material.dart';
import '../models/admin_models.dart';
import '../services/admin_api_service.dart';
import '../theme/admin_theme.dart';
import '../widgets/admin_widgets.dart';

class ProductEditPage extends StatefulWidget {
  final AdminProduct? product;

  const ProductEditPage({super.key, this.product});

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _priceController;
  late final TextEditingController _discountController;
  late final TextEditingController _stockController;
  late String _category;
  late String _storeId;
  late bool _isAvailable;

  final _categories = ['Food', 'Gym & Fitness', 'Use & Throw', 'Grocery'];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _descController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(
      text: p != null ? (p.pricePaise / 100).toStringAsFixed(0) : '',
    );
    _discountController = TextEditingController(
      text: p != null ? (p.discountPaise / 100).toStringAsFixed(0) : '0',
    );
    _stockController = TextEditingController(
      text: p != null ? p.stockCount.toString() : '50',
    );
    _category = p?.category ?? _categories.first;
    _storeId = p?.storeId ?? 'store_1';
    _isAvailable = p?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final service = AdminApiService();
    final price = (double.tryParse(_priceController.text) ?? 0 * 100).round() * 100;
    final discount = (double.tryParse(_discountController.text) ?? 0 * 100).round() * 100;
    final stock = int.tryParse(_stockController.text) ?? 0;

    final store = service.stores.firstWhere(
      (s) => s.id == _storeId,
      orElse: () => service.stores.first,
    );

    final saved = AdminProduct(
      id: widget.product?.id ?? 'prod_${DateTime.now().millisecondsSinceEpoch}',
      storeId: store.id,
      storeName: store.name,
      name: _nameController.text.trim(),
      category: _category,
      description: _descController.text.trim(),
      pricePaise: price,
      discountPaise: discount,
      isAvailable: _isAvailable,
      stockCount: stock,
    );

    service.saveProduct(saved);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.product != null ? 'Product updated successfully' : 'Product added to catalogue'),
      ),
    );
    Navigator.of(context).pop();
  }

  void _delete() {
    if (widget.product == null) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AdminColors.card,
        title: const Text('Delete Product?'),
        content: Text('Are you sure you want to remove "${widget.product!.name}" from the catalogue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AdminColors.muted)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AdminColors.red),
            onPressed: () {
              AdminApiService().deleteProduct(widget.product!.id);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product removed.')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = AdminApiService();
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Update Product' : 'Add New Product'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AdminColors.red),
              tooltip: 'Delete Product',
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          children: [
            ClayPanel(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('General Information', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      hintText: 'e.g. Royal Chicken Biryani',
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Product name required' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _descController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Detailed product details and ingredients',
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _category,
                    dropdownColor: AdminColors.raised,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _category = v!),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _storeId,
                    dropdownColor: AdminColors.raised,
                    decoration: const InputDecoration(labelText: 'Assigned Store'),
                    items: service.stores
                        .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                        .toList(),
                    onChanged: (v) => setState(() => _storeId = v!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ClayPanel(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pricing & Inventory', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price (₹)',
                            prefixText: '₹ ',
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Price required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _discountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Discount (₹)',
                            prefixText: '₹ ',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Stock Units',
                      hintText: 'Available quantity in stock',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Available for Sale', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Visible to customers in the catalog', style: TextStyle(color: AdminColors.muted, fontSize: 12)),
                        ],
                      ),
                      Switch(
                        value: _isAvailable,
                        activeColor: AdminColors.green,
                        onChanged: (v) => setState(() => _isAvailable = v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check_circle_outline),
              label: Text(isEditing ? 'Save Changes' : 'Create Product'),
              style: FilledButton.styleFrom(
                backgroundColor: AdminColors.orange,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
