
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
      final matchesCategory = _selectedCategory == 'Semua' ||
          task.category == _selectedCategory;

      final matchesSearch =
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.category.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get totalCount => _tasks.length;
  int get completedCount =>
      _tasks.where((t) => t.isCompleted).length;
  int get pendingCount =>
      _tasks.where((t) => !t.isCompleted).length;

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

  // UPDATE TASK
  Future<void> updateTask(
    String id,
    TaskModel updatedTask,
  ) async {
    final result = await _repository.updateTask(id, updatedTask);

    final index = _tasks.indexWhere((t) => t.id == id);

    if (index != -1) {
      _tasks[index] = result;
      notifyListeners();
    }
  }

  // TOGGLE TASK COMPLETION + OPTIMISTIC UPDATE
  Future<bool> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);

    if (index == -1) {
      throw Exception('Tugas tidak ditemukan.');
    }

    final originalTask = _tasks[index];
    final newStatus = !originalTask.isCompleted;

    final updatedTask = TaskModel(
      id: originalTask.id,
      title: originalTask.title,
      description: originalTask.description,
      category: originalTask.category,
      priority: originalTask.priority,
      dueDate: originalTask.dueDate,
      isCompleted: newStatus,
    );

    // Ubah tampilan langsung
    _tasks[index] = updatedTask;
    notifyListeners();

    try {
      // Simpan perubahan ke Supabase
      final result = await _repository.updateTask(
        id,
        updatedTask,
      );

      _tasks[index] = result;
      notifyListeners();

      return result.isCompleted;
    } catch (e) {
      // Kembalikan status jika gagal
      _tasks[index] = originalTask;
      notifyListeners();

      throw Exception(
        'Gagal memperbarui tugas. Periksa koneksi internet.',
      );
    }
  }

  // DELETE TASK
  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // SEARCH
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // CATEGORY FILTER
  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
