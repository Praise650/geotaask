import 'dart:ui';

class ProfileItem {
  final String? icon;
  final String? title;
  final String? subtitle;
  final VoidCallback? fn;

  ProfileItem({
    this.icon,
    this.title,
    this.subtitle,
    this.fn});
}