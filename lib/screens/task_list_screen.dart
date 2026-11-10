import 'package:flutter/material.dart';
import '../widgets/task_card.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Semua Tugas'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TaskCard(
            title: 'Laporan Praktikum Mobile',
            category: 'Pemrograman Mobile',
            dueDate: '12 Nov 2026',
            priority: 'High',
            isCompleted: false,
            onTap: () => Navigator.pushNamed(context, '/detail'),
          ),
          TaskCard(
            title: 'Makalah Etika Profesi',
            category: 'Umum',
            dueDate: '15 Nov 2026',
            priority: 'Medium',
            isCompleted: false,
            onTap: () => Navigator.pushNamed(context, '/detail'),
          ),
          TaskCard(
            title: 'Quiz Sistem Terdistribusi',
            category: 'Jaringan',
            dueDate: '20 Nov 2026',
            priority: 'Low',
            isCompleted: true,
            onTap: () => Navigator.pushNamed(context, '/detail'),
          ),
        ],
      ),
    );
  }
}