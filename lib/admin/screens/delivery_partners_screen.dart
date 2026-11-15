import 'package:flutter/material.dart';
import '../models/admin_models.dart';
import '../services/admin_api_service.dart';
import '../theme/admin_theme.dart';
import '../widgets/admin_widgets.dart';

class DeliveryPartnersPage extends StatefulWidget {
  const DeliveryPartnersPage({super.key});

  @override
  State<DeliveryPartnersPage> createState() => _DeliveryPartnersPageState();
}

class _DeliveryPartnersPageState extends State<DeliveryPartnersPage> {
  String _selectedFilter = 'All';
  final _filters = ['All', 'Online', 'Offline', 'Pending KYC'];

  @override
  Widget build(BuildContext context) {
    final service = AdminApiService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final filtered = service.riders.where((r) {
          if (_selectedFilter == 'Online') return r.isOnline;
          if (_selectedFilter == 'Offline') return !r.isOnline;
          if (_selectedFilter == 'Pending KYC') return r.kycStatus == KycStatus.pending;
          return true;
        }).toList();

        final onlineCount = service.riders.where((r) => r.isOnline).length;
        final pendingKyc = service.riders.where((r) => r.kycStatus == KycStatus.pending).length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Delivery Partner Fleet'),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            children: [
              // Fleet status summary bar
              Row(
                children: [
                  Expanded(
                    child: ClayPanel(
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xFF142E20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Online Fleet', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            '$onlineCount / ${service.riders.length}',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AdminColors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClayPanel(
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xFF382A12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('KYC Verification', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            '$pendingKyc Pending',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AdminColors.yellow),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

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
                        selectedColor: AdminColors.blue,
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
                '${filtered.length} delivery partner${filtered.length == 1 ? '' : 's'}',
                style: const TextStyle(color: AdminColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 10),

              ...filtered.map((rider) => _riderCard(context, rider, service)),
            ],
          ),
        );
      },
    );
  }

  Widget _riderCard(BuildContext context, AdminRider rider, AdminApiService service) {
    Color statusColor = rider.isOnline ? AdminColors.green : AdminColors.muted;
    String statusText = rider.isOnline ? 'Online' : 'Offline';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClayPanel(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AdminColors.raised,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.delivery_dining, color: AdminColors.blue, size: 24),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: AdminColors.card, width: 2),
                        ),
                      ),
                    ),
                  ],
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
                            rider.name,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: .15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${rider.phone} · ${rider.vehicleType} (${rider.vehicleNumber})',
                        style: const TextStyle(color: AdminColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AdminColors.line, height: 1),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _miniStat('Rating', '${rider.rating} ★'),
                _miniStat('Trips', '${rider.totalDeliveries} done'),
                _miniStat(
                  'KYC',
                  rider.kycStatus == KycStatus.verified ? 'Verified' : 'Pending Review',
                ),
                if (rider.activeOrderId != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AdminColors.orange.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AdminColors.orange.withValues(alpha: .35)),
                    ),
                    child: Text(
                      'On ${rider.activeOrderId}',
                      style: const TextStyle(color: AdminColors.orange, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => service.toggleRiderOnline(rider.id),
                    child: Text(
                      rider.isOnline ? 'Set Offline' : 'Set Online',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                if (rider.kycStatus == KycStatus.pending) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AdminColors.green),
                      onPressed: () {
                        service.updateRiderKyc(rider.id, KycStatus.verified);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${rider.name} verified and approved for deliveries.')),
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
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}
