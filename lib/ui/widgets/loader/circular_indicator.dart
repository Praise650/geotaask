import "package:flutter/material.dart";

class CircularIndicator extends StatelessWidget {
  const CircularIndicator(
      {super.key, this.width, this.height, this.bgColor, this.value});

  final double? width, height, value;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SizedBox(
        width: width ?? 20.0,
        height: height ?? 20.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          value: value,
          valueColor: AlwaysStoppedAnimation<Color>(
            bgColor ?? theme.primaryColor,
          ),
        ),
      ),
    );
  }
}
