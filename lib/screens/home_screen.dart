import 'package:flutter/material.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Hardcoded sample items for Task 2 only.
  final List<Map<String, String>> _items = [
    {
      'title': 'Buy milk',
      'priority': 'High',
      'description': '2 litres from store',
    },
    {
      'title': 'Study Flutter',
      'priority': 'Medium',
      'description': 'Finish UI chapter',
    },
    {'title': 'Call John', 'priority': 'Low', 'description': 'Project sync up'},
  ];

  Future<void> _addItem() async {
    final newItem = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(builder: (_) => const TaskFormScreen()),
    );
    if (newItem != null) {
      setState(() => _items.insert(0, newItem));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks & Notes')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Welcome! Manage your tasks & notes below.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  leading: const Icon(Icons.note_alt_outlined),
                  title: Text(item['title'] ?? ''),
                  subtitle: Text(
                    '${item['priority']} • ${item['description']}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
