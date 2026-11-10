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
    
    final task = taskProvider.tasks.firstWhere(
      (t) => t.id == taskId,
      orElse: () => taskProvider.tasks.first,
    );

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
                  title: const Text('Hapus Tugas'),
                  content: const Text('Apakah Anda yakin ingin menghapus tugas ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        taskProvider.deleteTask(task.id!);
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tugas berhasil dihapus')),
                        );
                      },
                      child: const Text('Hapus', style: TextStyle(color: Colors.red)),
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Chip(
              avatar: const Icon(Icons.book, size: 16),
              label: Text(task.category),
            ),
            const Divider(height: 32),
            const Text(
              'Deskripsi:',
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