import 'package:flutter/material.dart';
import '../models/task_model.dart';

enum TaskState { initial, loading, loaded, error }

class TaskProvider extends ChangeNotifier {
  TaskState _state = TaskState.loaded;
  String _errorMessage = '';
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

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

  TaskState get state => _state;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  // Shared State: Filter pencarian dan kategori
  List<TaskModel> get tasks {
    return _tasks.where((task) {
      final matchesCategory = _selectedCategory == 'Semua' || task.category == _selectedCategory;
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

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