import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/task_form_screen.dart';
import 'services/prefs_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isDark = await PrefsService.getIsDarkMode();
  runApp(TaskNotesApp(initialDarkMode: isDark));
}

class TaskNotesApp extends StatefulWidget {
  final bool initialDarkMode;
  const TaskNotesApp({super.key, required this.initialDarkMode});

  @override
  State<TaskNotesApp> createState() => _TaskNotesAppState();
}

class _TaskNotesAppState extends State<TaskNotesApp> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.initialDarkMode;
  }

  void _onThemeChanged(bool value) {
    setState(() => _isDark = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Notes Manager',
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routes: {TaskFormScreen.route: (_) => const TaskFormScreen()},
      home: HomeScreen(
        isDarkMode: _isDark,
        onThemeChanged: (v) async {
          _onThemeChanged(v);
          await PrefsService.setIsDarkMode(v);
        },
      ),
    );
  }
}
