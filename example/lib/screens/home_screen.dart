import 'package:flutter/material.dart';

import 'checkbox_demo_screen.dart';
import 'combined_demo_screen.dart';
import 'date_demo_screen.dart';
import 'dropdown_demo_screen.dart';
import 'multi_select_demo_screen.dart';
import 'radio_demo_screen.dart';
import 'searchable_dropdown_demo_screen.dart';
import 'text_field_demo_screen.dart';
import 'time_demo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Engine — demos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DemoTile(
            title: 'TextField variants',
            subtitle: 'Text, email, phone, password with validations',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TextFieldDemoScreen(),
              ),
            ),
          ),
          _DemoTile(
            title: 'Dropdown',
            subtitle: 'Single-select with required validation',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DropdownDemoScreen(),
              ),
            ),
          ),
          _DemoTile(
            title: 'Radio',
            subtitle: 'Single-select as radio buttons with conditional field',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RadioDemoScreen(),
              ),
            ),
          ),
          _DemoTile(
            title: 'Checkbox',
            subtitle: 'Boolean toggle with mustBeTrue validation',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CheckboxDemoScreen(),
              ),
            ),
          ),
          _DemoTile(
            title: 'Multi-select',
            subtitle: 'Multiple checkboxes with min/max selection rules',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MultiSelectDemoScreen(),
              ),
            ),
          ),
          _DemoTile(
            title: 'Date',
            subtitle: 'Date picker with minAge validation and date range',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DateDemoScreen(),
              ),
            ),
          ),
          _DemoTile(
            title: 'Time',
            subtitle: 'Time picker with 12h and 24h formats',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TimeDemoScreen(),
              ),
            ),
          ),
          _DemoTile(
            title: 'Combined + conditional',
            subtitle: 'Cascading dropdowns with show/hide dependency',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CombinedDemoScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoTile extends StatelessWidget {
  const _DemoTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
