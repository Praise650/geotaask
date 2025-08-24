import 'package:flutter/material.dart';

class OnboardingStep {
  final String title;
  final String description;
  final Widget widget;

  const OnboardingStep({
    required this.title,
    required this.description,
    required this.widget,
  });
}