import 'package:flutter/material.dart';

class BaseBottomSheet extends StatelessWidget {
  final ContentBuilder builder;
  final bool showHandleBar;
  final Color? handleBarColor;
  final Color? backgroundColor;
  final bool hasScrollableChild;
  final double? multiplier;

  const BaseBottomSheet({
    super.key,
    required this.builder,
    this.showHandleBar = false,
    this.handleBarColor,
    this.backgroundColor,
    this.hasScrollableChild = false,
    this.multiplier,
  });

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    double normPadding = 14.0;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        height: MediaQuery.sizeOf(context).height * (multiplier ?? .5),
        padding: EdgeInsets.only(top: normPadding, right: 20, left: 20),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showHandleBar)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 7,
                    width: 35,
                    decoration: BoxDecoration(
                      color: const Color(0XFFEDEDED),
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            Builder(
              builder: (context) {
                Widget child = Container(
                  constraints: BoxConstraints(minHeight: screen.height * 0.10),
                  child: builder(context, screen),
                );
                if (hasScrollableChild) {
                  return Expanded(
                    child: child,
                  );
                } else {
                  return child;
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

typedef ContentBuilder = Widget Function(BuildContext context, Size screen);
