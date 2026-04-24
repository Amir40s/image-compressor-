import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'app_text.dart';


class AppButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  // Sizing
  final double? height;
  final double? width;
  final EdgeInsets? padding;

  final double? radius;
  final double borderWidth;
  final Color? borderColor;

  final Color? buttonColor;
  final Color? textColor;

  // Typography
  final FontWeight fontWeight;
  final double? fontSize;

  // Alignment
  final Alignment alignment;

  // Loader
  final bool loader;
  final bool isGradient,isGradientDisable;
  final Gradient? gradient;
  // Icons
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AppButtonWidget({
    super.key,
    this.gradient,
    required this.text,
    this.onPressed,
    this.height,
    this.width,
    this.padding,
    this.radius,
    this.borderWidth = 1,
    this.borderColor,
    this.buttonColor,
    this.textColor,
    this.fontWeight = FontWeight.w400,
    this.fontSize,
    this.alignment = Alignment.center,
    this.loader = false,
    this.isGradient = false,
    this.isGradientDisable = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasBorder = borderColor != null;
    final bool isDisabled = loader || onPressed == null;
    final double resolvedRadius = radius ?? 14;

    return Align(
      alignment: alignment,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 160),
        opacity: isDisabled ? 0.65 : 1,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(resolvedRadius),
          child: Ink(

            child: InkWell(
              borderRadius: BorderRadius.circular(resolvedRadius),
              onTap: isDisabled ? null : onPressed,
              child: Container(
                height: height,
                width: width,
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: gradient == null
                      ? (buttonColor ??
                      (isGradient ? Colors.transparent : AppColors.textSecondary))
                      : null,
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(resolvedRadius),
                  border: hasBorder
                      ? Border.all(
                    color: borderColor!,
                    width: borderWidth,
                  )
                      : Border.all(color: Colors.transparent),
                ),
                child: loader
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.indigo,
                    strokeWidth: 2,
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: AppText(
                        text,
                        textAlign: TextAlign.center,
                        type: AppTextType.micro,
                        color: textColor ?? Colors.white,
                        fontWeight: fontWeight,
                        fontSize: fontSize ?? 16,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (suffixIcon != null) ...[
                      const SizedBox(width: 8),
                      suffixIcon!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
