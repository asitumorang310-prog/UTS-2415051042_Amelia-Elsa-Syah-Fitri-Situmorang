import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [
    TaskModel(
      id: '1',
      title: 'Laporan Praktikum Mobile',
      description: 'Menyelesaikan mini project TaskMate menggunakan Provider dan Supabase.',
      category: 'Pemrograman Mobile',
      priority: 'High',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      isCompleted: false,
    ),
    TaskModel(
      id: '2',
      title: 'Makalah Etika Profesi',
      description: 'Menyusun kajian etika profesi dalam bidang teknologi informasi.',
      category: 'Umum',
      priority: 'Medium',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      isCompleted: true,
    ),
  ];

  List<TaskModel> get tasks => _tasks;

  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;

  void addTask(TaskModel task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void updateTask(String id, TaskModel updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void toggleTaskCompletion(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        category: task.category,
        priority: task.priority,
        dueDate: task.dueDate,
        isCompleted: !task.isCompleted,
      );
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}