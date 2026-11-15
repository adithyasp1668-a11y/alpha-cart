import 'package:flutter/material.dart';
import '../models/admin_models.dart';
import '../services/admin_api_service.dart';
import '../theme/admin_theme.dart';
import '../widgets/admin_widgets.dart';

class ProfitLossPage extends StatefulWidget {
  const ProfitLossPage({super.key});

  @override
  State<ProfitLossPage> createState() => _ProfitLossPageState();
}

class _ProfitLossPageState extends State<ProfitLossPage> {
  Period _period = Period.month;

  @override
  Widget build(BuildContext context) {
    final service = AdminApiService();
    final pnl = service.getPnLReport(_period);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit & Loss Statement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Export P&L',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('P&L report exported to CSV.')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          // Period selector
          Row(
            children: [
              _periodButton('Today', Period.today),
              const SizedBox(width: 8),
              _periodButton('This Week', Period.week),
              const SizedBox(width: 8),
              _periodButton('This Month', Period.month),
              const SizedBox(width: 8),
              _periodButton('This Year', Period.year),
            ],
          ),
          const SizedBox(height: 20),

          // Net Margin Highlight Card
          ClayPanel(
            color: const Color(0xFF1E3550),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'NET PLATFORM PROFIT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Colors.white70,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AdminColors.green.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AdminColors.green.withValues(alpha: .4)),
                      ),
                      child: Text(
                        '${pnl.netMarginPercent.toStringAsFixed(1)}% Margin',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AdminColors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  pnl.formattedProfit,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'From Gross Merchandising Value of ${pnl.formattedGmv}',
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Revenue Waterfall',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),

          // Waterfall ledger items
          _waterfallItem(
            title: 'Gross Merchandising Value (GMV)',
            subtitle: 'Total volume transacted across all stores',
            amount: pnl.formattedGmv,
            isPositive: null,
            icon: Icons.storefront_outlined,
          ),
          _waterfallItem(
            title: 'Merchant Commission Earned',
            subtitle: 'Average 12.5% platform commission',
            amount: '+${pnl.formattedCommission}',
            isPositive: true,
            icon: Icons.percent_rounded,
          ),
          _waterfallItem(
            title: 'Delivery Service Margin',
            subtitle: 'Fees collected minus rider payouts',
            amount: '+${pnl.formattedDeliveryDiff}',
            isPositive: true,
            icon: Icons.delivery_dining_outlined,
          ),
          _waterfallItem(
            title: 'Payment Gateway Charges',
            subtitle: 'Razorpay / Cashfree processing fee (~1.8%)',
            amount: '-${pnl.formattedGateway}',
            isPositive: false,
            icon: Icons.credit_card_outlined,
          ),
          _waterfallItem(
            title: 'Customer Refunds & Disputes',
            subtitle: 'Platform-funded order reconciliations',
            amount: '-${pnl.formattedRefunds}',
            isPositive: false,
            icon: Icons.undo_rounded,
          ),

          const SizedBox(height: 20),
          const Divider(color: AdminColors.line),
          const SizedBox(height: 12),

          // Category contribution breakdown
          const Text(
            'Commission Breakdown by Category',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),

          _categoryShare('Food & Beverages', '15.0%', '₹1,02,400', 0.58, AdminColors.orange),
          _categoryShare('Gym & Fitness Gear', '12.0%', '₹42,300', 0.24, AdminColors.purple),
          _categoryShare('Use & Throw Disposables', '10.0%', '₹21,800', 0.12, AdminColors.blue),
          _categoryShare('Daily Grocery', '8.0%', '₹11,625', 0.06, AdminColors.green),
        ],
      ),
    );
  }

  Widget _periodButton(String label, Period p) {
    final active = _period == p;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _period = p),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? AdminColors.orange : AdminColors.raised,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? AdminColors.orangeLight : AdminColors.line,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              color: active ? Colors.white : AdminColors.muted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _waterfallItem({
    required String title,
    required String subtitle,
    required String amount,
    required bool? isPositive,
    required IconData icon,
  }) {
    Color amountColor;
    if (isPositive == true) {
      amountColor = AdminColors.green;
    } else if (isPositive == false) {
      amountColor = AdminColors.red;
    } else {
      amountColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClayPanel(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AdminColors.raised,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: amountColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AdminColors.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryShare(
    String category,
    String rate,
    String total,
    double fraction,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              Text(
                '$total  ($rate)',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: AdminColors.raised,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 7,
            ),
          ),
        ],
      ),
    );
  }
}
