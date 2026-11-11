import 'package:flutter/material.dart';

import '../models/customer_product.dart';
import '../theme/customer_theme.dart';

class CustomerClay extends StatelessWidget {
  const CustomerClay({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.color = CustomerColors.card,
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
          Color.lerp(color, Colors.white, .05)!,
          color,
          Color.lerp(color, Colors.black, .15)!,
        ],
      ),
      borderRadius: BorderRadius.circular(21),
      border: Border.all(color: Colors.white.withValues(alpha: .08)),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withValues(alpha: .03),
          blurRadius: 5,
          offset: const Offset(-2, -2),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: .55),
          blurRadius: 17,
          offset: const Offset(6, 8),
        ),
        BoxShadow(
          color: CustomerColors.orange.withValues(alpha: .035),
          blurRadius: 18,
          spreadRadius: -8,
        ),
      ],
    ),
    child: child,
  );
}

class CustomerButton extends StatelessWidget {
  const CustomerButton({
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
        colors: [CustomerColors.orangeLight, CustomerColors.orange],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: CustomerColors.orange.withValues(alpha: .2),
          blurRadius: 14,
          offset: const Offset(0, 5),
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
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}

class CustomerProductCard extends StatelessWidget {
  const CustomerProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdd,
    required this.onTap,
  });
  final CustomerProduct product;
  final int quantity;
  final VoidCallback onAdd, onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: CustomerClay(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [CustomerColors.raised, CustomerColors.card],
                ),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: Text(
                  product.emoji,
                  style: const TextStyle(fontSize: 38),
                ),
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            quantity > 0 ? '${product.name} · $quantity in cart' : product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '₹${product.price}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              if (product.oldPrice != null) ...[
                const SizedBox(width: 5),
                Text(
                  '₹${product.oldPrice}',
                  style: const TextStyle(
                    color: CustomerColors.muted,
                    fontSize: 9,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
              const Spacer(),
              InkWell(
                onTap: onAdd,
                borderRadius: BorderRadius.circular(9),
                child: Container(
                  width: 29,
                  height: 29,
                  decoration: BoxDecoration(
                    color: CustomerColors.orange,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Center(
                    child: Icon(Icons.add, size: 17, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class CustomerCategoryCard extends StatelessWidget {
  const CustomerCategoryCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.onTap,
  });
  final String name, subtitle, emoji;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(19),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: .96), color.withValues(alpha: .58)],
        ),
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: .18),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 9),
                ),
              ],
            ),
          ),
          Text(emoji, style: const TextStyle(fontSize: 28)),
        ],
      ),
    ),
  );
}

class CustomerSectionTitle extends StatelessWidget {
  const CustomerSectionTitle({
    super.key,
    required this.title,
    this.action,
    this.onTap,
  });
  final String title;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
      if (action != null)
        TextButton(
          onPressed: onTap,
          child: Text(
            action!,
            style: const TextStyle(color: CustomerColors.orange, fontSize: 11),
          ),
        ),
    ],
  );
}

class CustomerEmptyState extends StatelessWidget {
  const CustomerEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });
  final IconData icon;
  final String title, subtitle;
  final Widget? action;
  @override
  Widget build(BuildContext context) => CustomerClay(
    padding: const EdgeInsets.all(22),
    child: Column(
      children: [
        Icon(icon, color: CustomerColors.orange, size: 34),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 5),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: CustomerColors.muted,
            fontSize: 11,
            height: 1.45,
          ),
        ),
        if (action != null) ...[const SizedBox(height: 13), action!],
      ],
    ),
  );
}
