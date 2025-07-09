import 'package:flutter/material.dart';

class CustomFabWidget extends StatelessWidget {
  const CustomFabWidget({super.key, this.onTap, this.child});

  final void Function()? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(10),
          boxShadow: []
        ),
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
