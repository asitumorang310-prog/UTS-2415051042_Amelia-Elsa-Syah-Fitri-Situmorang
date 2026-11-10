import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

enum TaskStatus { initial, loading, loaded, error }

class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository = TaskRepository();

  TaskStatus _status = TaskStatus.initial;
  String _errorMessage = '';
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  List<TaskModel> _tasks = [];

  TaskStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

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

  Future<void> fetchTasksFromDatabase() async {
    _status = TaskStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _tasks = await _repository.fetchTasks();
      _status = TaskStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = TaskStatus.error;
    }
    notifyListeners();
  }

  // Fitur Create Data ke Supabase
  Future<void> addTask(TaskModel task) async {
    _status = TaskStatus.loading;
    notifyListeners();

    try {
      final newTask = await _repository.createTask(task);
      _tasks.insert(0, newTask);
      _status = TaskStatus.loaded;
      notifyListeners();
    } catch (e) {
      _status = TaskStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      rethrow;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
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