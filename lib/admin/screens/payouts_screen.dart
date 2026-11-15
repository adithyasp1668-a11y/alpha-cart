import 'package:flutter/material.dart';
import '../models/admin_models.dart';
import '../services/admin_api_service.dart';
import '../theme/admin_theme.dart';
import '../widgets/admin_widgets.dart';

class PayoutsPage extends StatefulWidget {
  const PayoutsPage({super.key});

  @override
  State<PayoutsPage> createState() => _PayoutsPageState();
}

class _PayoutsPageState extends State<PayoutsPage> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final service = AdminApiService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final pending = service.payouts.where((p) => p.status == 'PENDING').toList();

        int totalPendingPaise = 0;
        for (final p in pending) {
          totalPendingPaise += p.amountPaise;
        }

        final displayed = service.payouts.where((p) {
          if (_filter == 'Pending') return p.status == 'PENDING';
          if (_filter == 'Settled') return p.status == 'SETTLED';
          return true;
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Payouts & Settlements'),
            actions: [
              IconButton(
                icon: const Icon(Icons.history_rounded),
                tooltip: 'Settlement History',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Viewing past 90 days payout logs.')),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
            children: [
              // Pending Total Card
              ClayPanel(
                color: const Color(0xFF2C2214),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL PENDING SETTLEMENTS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                            color: Colors.white70,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AdminColors.yellow.withValues(alpha: .2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AdminColors.yellow.withValues(alpha: .35)),
                          ),
                          child: Text(
                            '${pending.length} Batches',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AdminColors.yellow),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '₹${(totalPendingPaise / 100).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Automated bank NEFT/IMPS & UPI transfers schedule: Daily 11:00 PM',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AdminColors.yellow,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: pending.isEmpty
                            ? null
                            : () => _confirmSettleAll(context, service, totalPendingPaise),
                        icon: const Icon(Icons.flash_on_rounded, size: 18),
                        label: const Text('Disburse All Pending Payouts', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Filter choices
              Row(
                children: ['All', 'Pending', 'Settled'].map((f) {
                  final active = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: active,
                      selectedColor: AdminColors.yellow,
                      backgroundColor: AdminColors.raised,
                      labelStyle: TextStyle(
                        color: active ? Colors.black : AdminColors.muted,
                        fontWeight: active ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              Text(
                '${displayed.length} settlement records',
                style: const TextStyle(color: AdminColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 10),

              ...displayed.map((payout) => _payoutRow(context, payout, service)),
            ],
          ),
        );
      },
    );
  }

  Widget _payoutRow(BuildContext context, AdminPayout payout, AdminApiService service) {
    final isPending = payout.status == 'PENDING';
    final isStore = payout.beneficiaryType == 'STORE';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClayPanel(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isStore ? AdminColors.green.withValues(alpha: .15) : AdminColors.blue.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isStore ? Icons.storefront : Icons.delivery_dining,
                color: isStore ? AdminColors.green : AdminColors.blue,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payout.beneficiaryName,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${payout.bankOrUpi} · ${payout.beneficiaryType}',
                    style: const TextStyle(color: AdminColors.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  payout.formattedAmount,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
                const SizedBox(height: 4),
                if (isPending)
                  InkWell(
                    onTap: () {
                      service.settlePayouts(payoutIds: [payout.id]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Transferred ${payout.formattedAmount} to ${payout.beneficiaryName}')),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AdminColors.yellow.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AdminColors.yellow.withValues(alpha: .4)),
                      ),
                      child: const Text(
                        'Settle Now',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AdminColors.yellow),
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AdminColors.green.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Settled',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AdminColors.green),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSettleAll(BuildContext context, AdminApiService service, int totalPaise) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AdminColors.card,
        title: const Text('Disburse All Settlements?'),
        content: Text(
          'Initiate electronic transfers for ₹${(totalPaise / 100).toStringAsFixed(0)} across all pending sellers and delivery partners?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AdminColors.muted)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AdminColors.yellow, foregroundColor: Colors.black),
            onPressed: () {
              service.settlePayouts();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All pending payouts disbursed successfully.')),
              );
            },
            child: const Text('Confirm & Disburse'),
          ),
        ],
      ),
    );
  }
}
