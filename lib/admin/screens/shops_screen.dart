import 'package:flutter/material.dart';
import '../models/admin_models.dart';
import '../services/admin_api_service.dart';
import '../theme/admin_theme.dart';
import '../widgets/admin_widgets.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  String _selectedFilter = 'All';
  final _filters = ['All', 'Pending KYC', 'Verified', 'Closed'];

  @override
  Widget build(BuildContext context) {
    final service = AdminApiService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final filtered = service.stores.where((s) {
          if (_selectedFilter == 'Pending KYC') return s.kycStatus == KycStatus.pending;
          if (_selectedFilter == 'Verified') return s.kycStatus == KycStatus.verified;
          if (_selectedFilter == 'Closed') return !s.isOpen;
          return true;
        }).toList();

        final pendingCount = service.stores.where((s) => s.kycStatus == KycStatus.pending).length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Shops & Sellers'),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            children: [
              // Summary banner if pending KYC exists
              if (pendingCount > 0)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AdminColors.yellow.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AdminColors.yellow.withValues(alpha: .35)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AdminColors.yellow),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '$pendingCount seller application${pendingCount > 1 ? 's' : ''} awaiting KYC approval.',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AdminColors.yellow),
                        ),
                      ),
                    ],
                  ),
                ),

              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final active = _selectedFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: active,
                        selectedColor: AdminColors.green,
                        backgroundColor: AdminColors.raised,
                        labelStyle: TextStyle(
                          color: active ? Colors.white : AdminColors.muted,
                          fontWeight: active ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        onSelected: (_) => setState(() => _selectedFilter = f),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                '${filtered.length} registered merchant${filtered.length == 1 ? '' : 's'}',
                style: const TextStyle(color: AdminColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 10),

              ...filtered.map((store) => _storeCard(context, store, service)),
            ],
          ),
        );
      },
    );
  }

  Widget _storeCard(BuildContext context, AdminStore store, AdminApiService service) {
    Color kycColor;
    String kycText;
    switch (store.kycStatus) {
      case KycStatus.verified:
        kycColor = AdminColors.green;
        kycText = 'KYC Verified';
        break;
      case KycStatus.pending:
        kycColor = AdminColors.yellow;
        kycText = 'KYC Pending';
        break;
      case KycStatus.rejected:
        kycColor = AdminColors.red;
        kycText = 'KYC Rejected';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ClayPanel(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AdminColors.raised,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.storefront, color: AdminColors.green, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              store.name,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: kycColor.withValues(alpha: .18),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kycColor.withValues(alpha: .35)),
                            ),
                            child: Text(
                              kycText,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kycColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${store.category} · ${store.ownerName} (${store.phone})',
                        style: const TextStyle(color: AdminColors.muted, fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        store.address,
                        style: const TextStyle(color: AdminColors.muted, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: AdminColors.line, height: 1),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _miniStat('Rating', '${store.rating} ★'),
                _miniStat('Products', '${store.totalProducts}'),
                _miniStat('Orders', '${store.totalOrders}'),
                InkWell(
                  onTap: () => _editCommissionDialog(context, store, service),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: _miniStat('Commission', '${store.commissionRate}% ✎'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: store.isOpen ? AdminColors.red : AdminColors.green,
                      ),
                    ),
                    onPressed: () => service.toggleStoreOpen(store.id),
                    child: Text(
                      store.isOpen ? 'Force Close' : 'Open Store',
                      style: TextStyle(
                        color: store.isOpen ? AdminColors.red : AdminColors.green,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                if (store.kycStatus == KycStatus.pending) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AdminColors.green),
                      onPressed: () {
                        service.updateStoreKyc(store.id, KycStatus.verified);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${store.name} KYC approved.')),
                        );
                      },
                      child: const Text('Approve KYC', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AdminColors.muted, fontSize: 10)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  void _editCommissionDialog(BuildContext context, AdminStore store, AdminApiService service) {
    final controller = TextEditingController(text: store.commissionRate.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AdminColors.card,
        title: Text('Commission for ${store.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter platform commission percentage for this store:'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Commission %',
                suffixText: '%',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AdminColors.muted)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AdminColors.orange),
            onPressed: () {
              final rate = double.tryParse(controller.text);
              if (rate != null) {
                service.updateStoreCommission(store.id, rate);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Commission updated to $rate%')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
