import 'package:flutter/material.dart';
import 'task_form_screen.dart';
import '../db/database_helper.dart';
import '../models/task_item.dart';

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
  late Future<List<TaskItem>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _tasksFuture = DatabaseHelper.instance.getAllTasks();
    setState(() {});
  }

  Future<void> _addItem() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const TaskFormScreen()),
    );
    if (added == true) _reload();
  }

  Future<void> _deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    _reload();
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
            child: FutureBuilder<List<TaskItem>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data ?? const <TaskItem>[];
                if (items.isEmpty) {
                  return const Center(child: Text('No tasks yet. Tap + to add.'));
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final t = items[index];
                    return Dismissible(
                      key: ValueKey(t.id ?? index),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        if (t.id != null) _deleteTask(t.id!);
                      },
                      child: ListTile(
                        leading: const Icon(Icons.note_alt_outlined),
                        title: Text(t.title),
                        subtitle: Text('${t.priority} • ${t.description}'),
                      ),
                    );
                  },
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
