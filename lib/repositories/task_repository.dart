import '../models/task_model.dart';
import '../services/supabase_service.dart';

class TaskRepository {
  final SupabaseService _supabaseService = SupabaseService();

  Future<List<TaskModel>> fetchTasks() async {
    return await _supabaseService.getTasks();
  }

  Future<TaskModel> createTask(TaskModel task) async {
    return await _supabaseService.insertTask(task);
  }

  Future<TaskModel> updateTask(String id, TaskModel task) async {
    return await _supabaseService.updateTask(id, task);
  }

  Future<void> deleteTask(String id) async {
    return await _supabaseService.deleteTask(id);
  }
}