import 'dart:ui';
import 'package:flutter/material.dart';

/// Item descriptor for [LuxuryNavigationBar].
class LuxuryNavItem {
  const LuxuryNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int badgeCount;
}

/// Ultra-luxurious floating glass-dock navigation bar with micro-glow indicators,
/// smooth animated capsules, and refined typography.
class LuxuryNavigationBar extends StatelessWidget {
  const LuxuryNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
    this.accentColor,
    this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 14),
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<LuxuryNavItem> items;
  final Color? accentColor;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = accentColor ?? theme.colorScheme.primary;

    // Luxury palette
    final barBgColor = isDark
        ? const Color(0xFF101217).withValues(alpha: 0.88)
        : Colors.white.withValues(alpha: 0.90);

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : const Color(0xFFE2E6EE).withValues(alpha: 0.90);

    final highlightRim = isDark
        ? Colors.white.withValues(alpha: 0.18)
        : Colors.white;

    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Padding(
        padding: margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                color: barBgColor,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: borderColor, width: 1.2),
                boxShadow: [
                  // Ambient diffuse shadow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                    spreadRadius: 2,
                  ),
                  // Subtle brand neon underglow
                  BoxShadow(
                    color: primary.withValues(alpha: isDark ? 0.14 : 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                  // Top inner glass reflection
                  BoxShadow(
                    color: highlightRim.withValues(alpha: isDark ? 0.06 : 0.8),
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected = index == selectedIndex;

                  return Expanded(
                    child: _LuxuryNavTab(
                      item: item,
                      isSelected: isSelected,
                      primaryColor: primary,
                      isDark: isDark,
                      onTap: () => onTap(index),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LuxuryNavTab extends StatefulWidget {
  const _LuxuryNavTab({
    required this.item,
    required this.isSelected,
    required this.primaryColor,
    required this.isDark,
    required this.onTap,
  });

  final LuxuryNavItem item;
  final bool isSelected;
  final Color primaryColor;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_LuxuryNavTab> createState() => _LuxuryNavTabState();
}

class _LuxuryNavTabState extends State<_LuxuryNavTab> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    final unselectedColor = widget.isDark
        ? const Color(0xFF7A8293)
        : const Color(0xFF8690A2);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isDown = true),
      onTapUp: (_) {
        setState(() => _isDown = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isDown = false),
      child: AnimatedScale(
        scale: _isDown ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: widget.isSelected ? 12 : 8,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? widget.primaryColor.withValues(alpha: widget.isDark ? 0.16 : 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              border: widget.isSelected
                  ? Border.all(
                      color: widget.primaryColor.withValues(alpha: widget.isDark ? 0.35 : 0.28),
                      width: 1,
                    )
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with badge & micro-glow
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (widget.isSelected)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: widget.primaryColor.withValues(alpha: 0.35),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    Icon(
                      widget.isSelected ? widget.item.activeIcon : widget.item.icon,
                      size: widget.isSelected ? 23 : 21,
                      color: widget.isSelected ? widget.primaryColor : unselectedColor,
                    ),
                    if (widget.item.badgeCount > 0)
                      Positioned(
                        top: -4,
                        right: -8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: widget.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: widget.isDark ? const Color(0xFF101217) : Colors.white,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.primaryColor.withValues(alpha: 0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.item.badgeCount > 99 ? '99+' : '${widget.item.badgeCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                // Label with luxury styling
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: widget.isSelected ? FontWeight.w800 : FontWeight.w500,
                    letterSpacing: widget.isSelected ? 0.2 : 0,
                    color: widget.isSelected ? widget.primaryColor : unselectedColor,
                    fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
                  ),
                  child: Text(
                    widget.item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
