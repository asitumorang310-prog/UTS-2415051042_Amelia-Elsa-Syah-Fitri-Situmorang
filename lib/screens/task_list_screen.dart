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
          : LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth >= 600;

                if (isWide) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
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
                  );
                }

                return ListView.builder(
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
                );
              },
            ),
    );
  }
}