import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/task_form_screen.dart';

void main() {
  runApp(const TaskNotesApp());
}

class TaskNotesApp extends StatelessWidget {
  const TaskNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Notes Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routes: {
        TaskFormScreen.route: (_) => const TaskFormScreen(),
      },
      home: const HomeScreen(),
    );
  }
}
