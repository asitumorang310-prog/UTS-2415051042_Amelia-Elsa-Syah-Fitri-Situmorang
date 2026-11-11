import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/task_provider.dart';
import 'providers/quote_provider.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/task_detail_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/edit_task_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zrzvmvbcavaivqismdto.supabase.co',
    anonKey: 'sb_publishable_-S1U4PTGwXueX3hqoIl1Ng_NmSzzejY',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()..fetchTasksFromDatabase()),
        ChangeNotifierProvider(create: (_) => QuoteProvider()..fetchQuote()),
      ],
      child: const TaskMateApp(),
    ),
  );
}

class TaskMateApp extends StatelessWidget {
  const TaskMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFBF7F9), // Background Soft Pink/Off-White
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF48FB1), // Soft Pink
          primary: const Color(0xFFE91E63),   // Deep Pink
          secondary: const Color(0xFF81C784), // Pastel Green
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigationScreen(),
        '/tasks': (context) => const TaskListScreen(),
        '/detail': (context) => const TaskDetailScreen(),
        '/add': (context) => const AddTaskScreen(),
        '/edit': (context) => const EditTaskScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}