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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
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