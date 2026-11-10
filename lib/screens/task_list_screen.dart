import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Semua Tugas (${taskProvider.totalCount})'),
      ),
      body: taskProvider.tasks.isEmpty
          ? const Center(child: Text('Daftar tugas masih kosong.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return TaskCard(
                  title: task.title,
                  category: task.category,
                  dueDate: "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}",
                  priority: task.priority,
                  isCompleted: task.isCompleted,
                  onTap: () => Navigator.pushNamed(context, '/detail', arguments: task.id),
                  onToggle: () => taskProvider.toggleTaskCompletion(task.id!),
                );
              },
            ),
    );
  }
}