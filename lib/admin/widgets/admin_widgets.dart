import 'package:flutter/material.dart';

import '../theme/admin_theme.dart';

class ClayPanel extends StatelessWidget {
  const ClayPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.color = AdminColors.card,
  });
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: Colors.white.withValues(alpha: .055)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .45),
          blurRadius: 14,
          offset: const Offset(5, 7),
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: .035),
          blurRadius: 8,
          offset: const Offset(-3, -3),
        ),
      ],
    ),
    child: child,
  );
}

class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, required this.subtitle});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w800,
          letterSpacing: -.5,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        subtitle,
        style: const TextStyle(color: AdminColors.muted, fontSize: 13),
      ),
    ],
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    required this.trailing,
    required this.onTap,
  });
  final String title, trailing;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      TextButton(
        onPressed: onTap,
        child: Text(
          trailing,
          style: const TextStyle(color: AdminColors.orange, fontSize: 12),
        ),
      ),
    ],
  );
}

class PeriodSelector extends StatefulWidget {
  const PeriodSelector({super.key});
  @override
  State<PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {
  String value = 'This month';
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: PopupMenuButton<String>(
      onSelected: (v) => setState(() => value = v),
      color: AdminColors.raised,
      itemBuilder: (_) => [
        'Today',
        'This week',
        'This month',
        'This year',
      ].map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: AdminColors.raised,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AdminColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, size: 18),
          ],
        ),
      ),
    ),
  );
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.delta,
    required this.icon,
    required this.tint,
  });
  final String title, value, delta;
  final IconData icon;
  final Color tint;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: .92, end: 1),
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeOutBack,
    builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
    child: ClayPanel(
      color: tint,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: Colors.white70),
              Icon(
                Icons.more_horiz,
                size: 17,
                color: Colors.white.withValues(alpha: .6),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.arrow_upward_rounded,
                color: AdminColors.green,
                size: 13,
              ),
              const SizedBox(width: 2),
              Text(
                delta,
                style: const TextStyle(
                  color: AdminColors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'vs last month',
                style: TextStyle(color: Colors.white54, fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class SalesChartCard extends StatelessWidget {
  const SalesChartCard({super.key});
  @override
  Widget build(BuildContext context) => ClayPanel(
    padding: const EdgeInsets.fromLTRB(16, 15, 16, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sales trend',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            Row(
              children: [
                Icon(Icons.circle, size: 7, color: AdminColors.orange),
                SizedBox(width: 5),
                Text(
                  'Sales',
                  style: TextStyle(color: AdminColors.muted, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 13),
        SizedBox(
          height: 150,
          width: double.infinity,
          child: CustomPaint(painter: _SalesPainter()),
        ),
        const SizedBox(height: 5),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1', style: _axis),
            Text('5', style: _axis),
            Text('10', style: _axis),
            Text('15', style: _axis),
            Text('20', style: _axis),
            Text('25', style: _axis),
            Text('30', style: _axis),
          ],
        ),
      ],
    ),
  );
  static const _axis = TextStyle(color: AdminColors.muted, fontSize: 9);
}

class _SalesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: .08)
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final points = <Offset>[
      const Offset(0, .78),
      const Offset(.12, .65),
      const Offset(.22, .7),
      const Offset(.33, .49),
      const Offset(.43, .55),
      const Offset(.55, .37),
      const Offset(.66, .45),
      const Offset(.78, .22),
      const Offset(.89, .29),
      const Offset(1, .08),
    ].map((p) => Offset(p.dx * size.width, p.dy * size.height)).toList();
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final mid = (points[i - 1].dx + points[i].dx) / 2;
      path.cubicTo(
        mid,
        points[i - 1].dy,
        mid,
        points[i].dy,
        points[i].dx,
        points[i].dy,
      );
    }
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          colors: [
            AdminColors.orange.withValues(alpha: .27),
            AdminColors.orange.withValues(alpha: 0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = AdminColors.orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    for (final p in points) {
      canvas.drawCircle(p, 3.2, Paint()..color = AdminColors.orange);
      canvas.drawCircle(p, 1.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AttentionRow extends StatelessWidget {
  const AttentionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
  final IconData icon;
  final String title, subtitle;
  final Color color;
  @override
  Widget build(BuildContext context) => ClayPanel(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: color, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(color: AdminColors.muted, fontSize: 11),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: AdminColors.muted, size: 20),
      ],
    ),
  );
}

class ActivityRow extends StatelessWidget {
  const ActivityRow({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    required this.time,
    required this.color,
  });
  final IconData icon;
  final String title, detail, time;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 13),
    child: Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color.withValues(alpha: .14),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                detail,
                style: const TextStyle(color: AdminColors.muted, fontSize: 10),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: const TextStyle(color: AdminColors.muted, fontSize: 10),
        ),
      ],
    ),
  );
}

class FilterChips extends StatelessWidget {
  const FilterChips({
    super.key,
    required this.values,
    required this.selected,
    required this.onSelected,
  });
  final List<String> values;
  final String selected;
  final ValueChanged<String> onSelected;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: values
          .map(
            (v) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(v),
                selected: selected == v,
                onSelected: (_) => onSelected(v),
                selectedColor: AdminColors.orange,
                backgroundColor: AdminColors.raised,
                side: BorderSide(
                  color: selected == v ? AdminColors.orange : AdminColors.line,
                ),
                labelStyle: TextStyle(
                  color: selected == v ? Colors.white : AdminColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 7),
              ),
            ),
          )
          .toList(),
    ),
  );
}

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.id,
    required this.shop,
    required this.detail,
    required this.amount,
    required this.icon,
    required this.color,
    required this.status,
  });
  final String id, shop, detail, amount, status;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => ClayPanel(
    padding: const EdgeInsets.all(14),
    child: Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    id,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                shop,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 7,
                    color: status == 'Cancelled'
                        ? AdminColors.red
                        : status == 'Completed'
                        ? AdminColors.green
                        : AdminColors.orange,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      '$detail  ·  $status',
                      style: const TextStyle(
                        color: AdminColors.muted,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class ManageTile extends StatelessWidget {
  const ManageTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(21),
      onTap: onTap,
      child: ClayPanel(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .14),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color, size: 21),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AdminColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AdminColors.muted),
          ],
        ),
      ),
    ),
  );
}

class CategoryProgress extends StatelessWidget {
  const CategoryProgress({
    super.key,
    required this.name,
    required this.value,
    required this.fraction,
    required this.color,
  });
  final String name, value;
  final double fraction;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(color: AdminColors.muted, fontSize: 12),
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 6,
            backgroundColor: AdminColors.raised,
            color: color,
          ),
        ),
      ],
    ),
  );
}

class SimpleDataRow extends StatelessWidget {
  const SimpleDataRow({super.key, required this.name, required this.value});
  final String name, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14),
    child: Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(color: AdminColors.muted, fontSize: 12),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ],
    ),
  );
}

class ProductRow extends StatelessWidget {
  const ProductRow({
    super.key,
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
  });
  final String name, category, price;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: ClayPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              color: AdminColors.raised,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AdminColors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: const TextStyle(
                    color: AdminColors.muted,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 5),
                const Row(
                  children: [
                    Icon(Icons.circle, size: 7, color: AdminColors.green),
                    SizedBox(width: 4),
                    Text(
                      'Available',
                      style: TextStyle(color: AdminColors.green, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          ),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Edit product'))),
            icon: const Icon(
              Icons.edit_outlined,
              size: 18,
              color: AdminColors.muted,
            ),
          ),
        ],
      ),
    ),
  );
}

class PartnerRow extends StatelessWidget {
  const PartnerRow({
    super.key,
    required this.name,
    required this.info,
    required this.status,
    required this.active,
  });
  final String name, info, status;
  final bool active;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: ClayPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AdminColors.raised,
            child: Icon(
              active ? Icons.storefront_outlined : Icons.person_outline,
              color: active ? AdminColors.orange : AdminColors.muted,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  info,
                  style: const TextStyle(
                    color: AdminColors.muted,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 7,
                      color: active ? AdminColors.green : AdminColors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        color: active ? AdminColors.green : AdminColors.red,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: active,
            onChanged: (_) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Availability updated')),
            ),
            activeColor: AdminColors.green,
          ),
        ],
      ),
    ),
  );
}

class PayoutSummary extends StatelessWidget {
  const PayoutSummary({super.key});
  @override
  Widget build(BuildContext context) => const ClayPanel(
    padding: EdgeInsets.all(18),
    color: Color(0xFF1B2421),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery partner payouts · This week',
          style: TextStyle(color: AdminColors.muted, fontSize: 11),
        ),
        SizedBox(height: 8),
        Text(
          '₹86,420',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 27),
        ),
        SizedBox(height: 13),
        SimpleDataRow(name: 'Total partners', value: '128'),
        SimpleDataRow(name: 'Total deliveries', value: '5,460'),
        SimpleDataRow(name: 'Average payout / order', value: '₹15.82'),
      ],
    ),
  );
}

class PayoutRow extends StatelessWidget {
  const PayoutRow({super.key, required this.name, required this.amount});
  final String name, amount;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: ClayPanel(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: AdminColors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    ),
  );
}

class PnlSummary extends StatelessWidget {
  const PnlSummary({super.key});
  @override
  Widget build(BuildContext context) => const ClayPanel(
    padding: EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profit & Loss · This month',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 17),
        SimpleDataRow(name: 'Total revenue', value: '₹3,68,450'),
        SimpleDataRow(name: 'Total expenses', value: '₹1,86,150'),
        SimpleDataRow(name: 'Net profit', value: '₹1,82,300'),
        SizedBox(height: 16),
        CategoryProgress(
          name: 'Food',
          value: '42%',
          fraction: .42,
          color: AdminColors.green,
        ),
        CategoryProgress(
          name: 'Grocery',
          value: '28%',
          fraction: .28,
          color: AdminColors.red,
        ),
        CategoryProgress(
          name: 'Gym & Fitness',
          value: '18%',
          fraction: .18,
          color: AdminColors.blue,
        ),
      ],
    ),
  );
}

class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.title,
    required this.detail,
    required this.icon,
  });
  final String title, detail;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: ManageTile(
      title: title,
      subtitle: detail,
      icon: icon,
      color: AdminColors.orange,
      onTap: () =>
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('$title settings'))),
    ),
  );
}
