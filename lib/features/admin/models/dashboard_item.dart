import 'package:flutter/material.dart';

class DashboardItem {
  const DashboardItem({
    required this.title,
    required this.icon,
    required this.page,
  });

  final String title;
  final IconData icon;
  final Widget page;
}