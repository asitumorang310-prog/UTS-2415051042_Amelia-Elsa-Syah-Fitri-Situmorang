import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/priority_badge.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskId = ModalRoute.of(context)?.settings.arguments as String?;
    final taskProvider = Provider.of<TaskProvider>(context);

    if (taskId == null || taskId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Tugas')),
        body: const Center(child: Text('Tugas tidak ditemukan.')),
      );
    }

    final taskIndex = taskProvider.tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Tugas')),
        body: const Center(child: Text('Data tugas telah dihapus.')),
      );
    }

    final task = taskProvider.tasks[taskIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, '/edit', arguments: task.id),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Konfirmasi Hapus'),
                  content: Text('Apakah Anda yakin ingin menghapus tugas "${task.title}" dari database?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        try {
                          await taskProvider.deleteTask(task.id!);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tugas berhasil dihapus dari Supabase!'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal menghapus tugas: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PriorityBadge(priority: task.priority),
                Text(
                  "Tenggat: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              task.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 8),
            Chip(
              avatar: const Icon(Icons.book, size: 16),
              label: Text(task.category),
            ),
            const Divider(height: 32),
            const Text(
              'Deskripsi Tugas:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              task.description.isEmpty ? 'Tidak ada deskripsi.' : task.description,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => taskProvider.toggleTaskCompletion(task.id!),
              icon: Icon(task.isCompleted ? Icons.undo : Icons.check_circle),
              label: Text(task.isCompleted ? 'Tandai Belum Selesai' : 'Tandai Selesai'),
              style: ElevatedButton.styleFrom(
                backgroundColor: task.isCompleted ? Colors.grey[300] : Colors.green[100],
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}