import 'package:flutter/material.dart';
import 'package:alpha_cart_auth/alpha_cart_auth.dart';
import '../models/admin_models.dart';
import '../services/admin_api_service.dart';
import '../theme/admin_theme.dart';
import '../widgets/admin_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double _foodComm;
  late double _gymComm;
  late double _dispComm;
  late double _grocComm;
  late int _baseDelivery;
  late int _perKmDelivery;
  late bool _codEnabled;
  late bool _maintenance;
  late String _gateway;

  @override
  void initState() {
    super.initState();
    final s = AdminApiService().settings;
    _foodComm = s.foodCommission;
    _gymComm = s.gymCommission;
    _dispComm = s.disposableCommission;
    _grocComm = s.groceryCommission;
    _baseDelivery = (s.baseDeliveryFeePaise / 100).round();
    _perKmDelivery = (s.perKmDeliveryFeePaise / 100).round();
    _codEnabled = s.codEnabled;
    _maintenance = s.maintenanceMode;
    _gateway = s.activeGateway;
  }

  void _saveSettings() {
    final service = AdminApiService();
    final updated = AdminPlatformSettings(
      foodCommission: _foodComm,
      gymCommission: _gymComm,
      disposableCommission: _dispComm,
      groceryCommission: _grocComm,
      baseDeliveryFeePaise: _baseDelivery * 100,
      perKmDeliveryFeePaise: _perKmDelivery * 100,
      codEnabled: _codEnabled,
      maintenanceMode: _maintenance,
      activeGateway: _gateway,
    );
    service.updateSettings(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Platform settings updated successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Save Settings',
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
        children: [
          // Platform Operations
          ClayPanel(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Operational Safety Switches', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Cash on Delivery (COD)'),
                  subtitle: const Text('Allow cash collection on order delivery', style: TextStyle(color: AdminColors.muted, fontSize: 12)),
                  value: _codEnabled,
                  activeColor: AdminColors.orange,
                  onChanged: (v) => setState(() => _codEnabled = v),
                ),
                const Divider(color: AdminColors.line),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Maintenance Mode'),
                  subtitle: const Text('Pause all checkout and new orders across apps', style: TextStyle(color: AdminColors.muted, fontSize: 12)),
                  value: _maintenance,
                  activeColor: AdminColors.red,
                  onChanged: (v) => setState(() => _maintenance = v),
                ),
                const Divider(color: AdminColors.line),
                const SizedBox(height: 8),
                const Text('Payment Gateway Provider', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _gateway,
                  dropdownColor: AdminColors.raised,
                  decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
                  items: ['Razorpay Sandbox', 'Cashfree Sandbox', 'Test Mock Driver']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _gateway = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Default Commissions
          ClayPanel(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Default Platform Commissions (%)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                _sliderTile('Food & Beverages', _foodComm, 5, 25, (v) => setState(() => _foodComm = v)),
                _sliderTile('Gym & Fitness Gear', _gymComm, 5, 25, (v) => setState(() => _gymComm = v)),
                _sliderTile('Use & Throw Disposables', _dispComm, 5, 20, (v) => setState(() => _dispComm = v)),
                _sliderTile('Daily Grocery', _grocComm, 2, 15, (v) => setState(() => _grocComm = v)),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Delivery Charges
          ClayPanel(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Delivery Pricing Formula', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Base Fee (First 3 km)', style: TextStyle(fontSize: 12, color: AdminColors.muted)),
                          const SizedBox(height: 6),
                          TextFormField(
                            initialValue: _baseDelivery.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(prefixText: '₹ '),
                            onChanged: (v) => _baseDelivery = int.tryParse(v) ?? _baseDelivery,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Rate per Extra km', style: TextStyle(fontSize: 12, color: AdminColors.muted)),
                          const SizedBox(height: 6),
                          TextFormField(
                            initialValue: _perKmDelivery.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(prefixText: '₹ '),
                            onChanged: (v) => _perKmDelivery = int.tryParse(v) ?? _perKmDelivery,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Admin User Profile & Sign Out
          ClayPanel(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Administrator Profile', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AdminColors.raised,
                      child: Icon(Icons.security_rounded, color: AdminColors.orange),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Adithya (Platform Super Admin)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('admin@alphacart.local · Role: ADMIN', style: TextStyle(color: AdminColors.muted, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const SignOutTile(accentColor: AdminColors.orange),
              ],
            ),
          ),
          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: _saveSettings,
            style: FilledButton.styleFrom(
              backgroundColor: AdminColors.orange,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save All Configurations'),
          ),
        ],
      ),
    );
  }

  Widget _sliderTile(String title, double val, double min, double max, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text('${val.toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.bold, color: AdminColors.orange)),
            ],
          ),
          Slider(
            value: val,
            min: min,
            max: max,
            divisions: ((max - min) * 2).round(),
            activeColor: AdminColors.orange,
            inactiveColor: AdminColors.raised,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
