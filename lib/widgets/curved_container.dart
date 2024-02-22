import 'package:flutter/material.dart';

class CustomCurvedContainer extends StatelessWidget {
  final Color? fillColor;
  final Color? borderColor;
  final Widget? child;
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsets? padding;
  const CustomCurvedContainer(
      {super.key,
      this.fillColor,
      this.borderColor,
      this.child,
      this.height,
      this.width,
      this.borderRadius,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 16)),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: 2,
        ),
        color: fillColor ?? Colors.white,
      ),
      padding: padding ?? EdgeInsets.zero,
      child: child ?? const SizedBox(),
    );
  }
}
