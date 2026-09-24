import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Widget? icon;
  final bool isLoading;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const CustomAuthButton({
    super.key,
    required this.text,
    this.onTap,
    this.icon,
    this.isLoading = false,
    this.backgroundColor =const Color(0xFF16181C),
    this.borderColor = const Color(0xFF2d2d2d), // Light border from screenshot
    this.textColor = Colors.white,
    //this.textColor = const Color(0xFF202124),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16), // Rounded pill curvature matching the image
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLoading ? null : onTap,
          child: Center(
            child: isLoading
                ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: textColor,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 12),
                ],
                Text(
                  text,
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    letterSpacing: 0.1,
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