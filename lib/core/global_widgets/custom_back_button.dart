import 'package:flutter/material.dart';

class CustomAppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? iconColor;

  const CustomAppBackButton({
    super.key,
    this.onTap,
    this.borderColor,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: 42,
        height: 52,
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFF1E2024),
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: borderColor ?? Colors.white.withValues(alpha: 0.14),
            width: 2.0,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.arrow_back_rounded,
          color: iconColor ?? Colors.white,
          size: 20,
        ),
      ),
    );
  }
}