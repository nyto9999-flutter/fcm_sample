// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;
  const NotificationBadge({
    super.key,
    required this.totalNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$totalNotifications',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ));
  }
}
