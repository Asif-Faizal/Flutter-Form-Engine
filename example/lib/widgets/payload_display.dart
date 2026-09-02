import 'dart:convert';

import 'package:flutter/material.dart';

/// Shows the submitted payload at the bottom of the screen.
class PayloadDisplay extends StatelessWidget {
  const PayloadDisplay({super.key, required this.payload});

  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    final serializable = payload.map(
      (key, value) => MapEntry(
        key,
        value is DateTime ? value.toIso8601String() : value,
      ),
    );
    final pretty = const JsonEncoder.withIndent('  ').convert(serializable);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Submitted payload',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 4),
          Text(
            pretty,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
          ),
        ],
      ),
    );
  }
}
