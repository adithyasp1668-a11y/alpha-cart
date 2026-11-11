import 'package:flutter/material.dart';

import '../theme/delivery_theme.dart';

class DeliveryClay extends StatelessWidget {
  const DeliveryClay({super.key, required this.child, this.padding = const EdgeInsets.all(15), this.color = DeliveryColors.card});
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(padding: padding, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color.lerp(color, Colors.white, .055)!, color, Color.lerp(color, Colors.black, .15)!]), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white.withValues(alpha: .09)), boxShadow: [BoxShadow(color: Colors.white.withValues(alpha: .035), blurRadius: 5, offset: const Offset(-2, -2)), BoxShadow(color: Colors.black.withValues(alpha: .55), blurRadius: 18, offset: const Offset(7, 9)), BoxShadow(color: DeliveryColors.orange.withValues(alpha: .045), blurRadius: 20, spreadRadius: -8)]), child: child);
}

class DeliveryHeader extends StatelessWidget {
  const DeliveryHeader({super.key, required this.title, this.subtitle});
  final String title;
  final String? subtitle;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, letterSpacing: -.6)), if (subtitle != null) ...[const SizedBox(height: 5), Text(subtitle!, style: const TextStyle(color: DeliveryColors.muted, fontSize: 13))]]);
}

class DeliveryButton extends StatelessWidget {
  const DeliveryButton({super.key, required this.label, required this.onPressed, this.icon});
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => DecoratedBox(decoration: BoxDecoration(gradient: const LinearGradient(colors: [DeliveryColors.orangeLight, DeliveryColors.orange]), borderRadius: BorderRadius.circular(17), boxShadow: [BoxShadow(color: DeliveryColors.orange.withValues(alpha: .22), blurRadius: 16, offset: const Offset(0, 6))]), child: FilledButton.icon(onPressed: onPressed, icon: icon == null ? const SizedBox.shrink() : Icon(icon), label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)), style: FilledButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)))));
}

class DeliveryMetric extends StatelessWidget {
  const DeliveryMetric({super.key, required this.title, required this.value, required this.icon, this.tint = DeliveryColors.card});
  final String title, value;
  final IconData icon;
  final Color tint;
  @override
  Widget build(BuildContext context) => DeliveryClay(color: tint, padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 18, color: Colors.white70), const SizedBox(height: 13), Text(title, style: const TextStyle(color: Colors.white70, fontSize: 10)), const SizedBox(height: 5), Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))]));
}

class DeliveryValueRow extends StatelessWidget {
  const DeliveryValueRow({super.key, required this.label, required this.value, this.emphasized = false});
  final String label, value;
  final bool emphasized;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 9), child: Row(children: [Expanded(child: Text(label, style: TextStyle(color: emphasized ? Colors.white : DeliveryColors.muted, fontSize: 12, fontWeight: emphasized ? FontWeight.w800 : FontWeight.w500))), Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: emphasized ? DeliveryColors.orange : Colors.white))]));
}
