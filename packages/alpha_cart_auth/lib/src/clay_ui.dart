import 'package:flutter/material.dart';

/// Claymorphic container widget providing 3D pillowy inflated clay appearance.
class ClayContainer extends StatelessWidget {
  const ClayContainer({
    super.key,
    required this.child,
    this.color,
    this.borderRadius = 24.0,
    this.padding = const EdgeInsets.all(20.0),
    this.depth = 12.0,
    this.spread = 1.0,
    this.isInset = false,
    this.border,
    this.width,
    this.height,
  });

  final Widget child;
  final Color? color;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double depth;
  final double spread;
  final bool isInset;
  final BoxBorder? border;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = color ?? (isDark ? const Color(0xFF1B1E26) : const Color(0xFFF3F5FA));

    final lightShadowColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.95);

    final darkShadowColor = isDark
        ? Colors.black.withValues(alpha: 0.65)
        : const Color(0xFFC8D0E0).withValues(alpha: 0.85);

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ??
            Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.white.withValues(alpha: 0.8),
              width: 1.5,
            ),
        boxShadow: isInset
            ? [
                BoxShadow(
                  color: darkShadowColor,
                  offset: Offset(depth / 2, depth / 2),
                  blurRadius: depth,
                  spreadRadius: -spread,
                ),
                BoxShadow(
                  color: lightShadowColor,
                  offset: Offset(-depth / 2, -depth / 2),
                  blurRadius: depth,
                  spreadRadius: -spread,
                ),
              ]
            : [
                BoxShadow(
                  color: darkShadowColor,
                  offset: Offset(depth * 0.7, depth * 0.7),
                  blurRadius: depth * 1.4,
                  spreadRadius: spread,
                ),
                BoxShadow(
                  color: lightShadowColor,
                  offset: Offset(-depth * 0.5, -depth * 0.5),
                  blurRadius: depth * 1.2,
                  spreadRadius: spread,
                ),
              ],
      ),
      child: child,
    );
  }
}

/// Pillowy 3D Clay button with tactile feedback.
class ClayButton extends StatefulWidget {
  const ClayButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.borderRadius = 18.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
    this.depth = 8.0,
    this.width,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double depth;
  final double? width;

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = widget.color ?? theme.colorScheme.primary;

    final depth = _isPressed ? widget.depth * 0.3 : widget.depth;

    return GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onPressed != null
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed!();
            }
          : null,
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: [
            // Bottom-right shadow
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.45),
              offset: Offset(0, depth * 1.2),
              blurRadius: depth * 2,
              spreadRadius: 1,
            ),
            // Top highlight for 3D clay gloss
            BoxShadow(
              color: Colors.white.withValues(alpha: isDark ? 0.2 : 0.4),
              offset: Offset(-depth * 0.4, -depth * 0.4),
              blurRadius: depth,
            ),
          ],
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}
