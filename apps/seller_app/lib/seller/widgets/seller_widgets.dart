import 'package:flutter/material.dart';

import '../theme/seller_theme.dart';

class SellerClay extends StatelessWidget {
  const SellerClay({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(15),
    this.color = SellerColors.card,
  });
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(color, Colors.white, .055)!,
          color,
          Color.lerp(color, Colors.black, .15)!,
        ],
      ),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: Colors.white.withValues(alpha: .09)),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withValues(alpha: .035),
          blurRadius: 5,
          offset: const Offset(-2, -2),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: .55),
          blurRadius: 18,
          offset: const Offset(7, 9),
        ),
        BoxShadow(
          color: SellerColors.orange.withValues(alpha: .04),
          blurRadius: 20,
          spreadRadius: -8,
        ),
      ],
    ),
    child: child,
  );
}

class SellerHeader extends StatelessWidget {
  const SellerHeader({super.key, required this.title, this.subtitle});
  final String title;
  final String? subtitle;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w800,
          letterSpacing: -.6,
        ),
      ),
      if (subtitle != null) ...[
        const SizedBox(height: 5),
        Text(
          subtitle!,
          style: const TextStyle(color: SellerColors.muted, fontSize: 13),
        ),
      ],
    ],
  );
}

class SellerButton extends StatelessWidget {
  const SellerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [SellerColors.orangeLight, SellerColors.orange],
      ),
      borderRadius: BorderRadius.circular(17),
      boxShadow: [
        BoxShadow(
          color: SellerColors.orange.withValues(alpha: .22),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: FilledButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
      style: FilledButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      ),
    ),
  );
}

class ZeroMetric extends StatelessWidget {
  const ZeroMetric({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.tint,
  });
  final String title, value;
  final IconData icon;
  final Color tint;
  @override
  Widget build(BuildContext context) => SellerClay(
    color: tint,
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 19, color: Colors.white70),
        const SizedBox(height: 15),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 21),
        ),
      ],
    ),
  );
}

class SellerEmptyState extends StatelessWidget {
  const SellerEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    this.action,
  });
  final IconData icon;
  final String title, detail;
  final Widget? action;
  @override
  Widget build(BuildContext context) => SellerClay(
    padding: const EdgeInsets.all(24),
    child: Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: SellerColors.orange.withValues(alpha: .13),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: SellerColors.orange, size: 27),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          detail,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: SellerColors.muted,
            fontSize: 12,
            height: 1.45,
          ),
        ),
        if (action != null) ...[const SizedBox(height: 16), action!],
      ],
    ),
  );
}
