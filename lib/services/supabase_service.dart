import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class SupabaseService {
  SupabaseClient get _client => Supabase.instance.client;

  // Read data dari Supabase
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _client
          .from('tasks')
          .select()
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data dari Supabase: $e');
    }
  }

  // Create / Insert data baru ke Supabase
  Future<TaskModel> insertTask(TaskModel task) async {
    try {
      final response = await _client
          .from('tasks')
          .insert(task.toJson())
          .select()
          .single();

      return TaskModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal menyimpan tugas baru ke Supabase: $e');
    }
  }

  // Update data tugas di Supabase
  Future<TaskModel> updateTask(String id, TaskModel task) async {
    try {
      final response = await _client
          .from('tasks')
          .update(task.toJson())
          .eq('id', id)
          .select()
          .single();

      return TaskModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal memperbarui tugas di Supabase: $e');
    }
  }

  // Delete data tugas dari Supabase
  Future<void> deleteTask(String id) async {
    try {
      await _client.from('tasks').delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus tugas dari Supabase: $e');
    }
  }
}