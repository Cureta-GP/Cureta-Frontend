import 'package:flutter/material.dart';

class UserRecordFilter {
  const UserRecordFilter({required this.id, required this.label});

  final String id;
  final String label;
}

class UserRecordItem {
  const UserRecordItem({
    required this.title,
    required this.status,
    required this.meta,
    required this.metaIcon,
    required this.isOngoing,
  });

  final String title;
  final String status;
  final String meta;
  final IconData metaIcon;
  final bool isOngoing;
}

class UserRecordFilterIds {
  static const all = 'all';
  static const ongoing = 'ongoing';
  static const past = 'past';
  static const recent = 'recent';
}
