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
        title: Text('Semua Tugas (${taskProvider.tasks.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Segarkan Data',
            onPressed: () async {
              await taskProvider.fetchTasksFromDatabase();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data berhasil diperbarui!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await taskProvider.fetchTasksFromDatabase();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data tugas diperbarui dari Supabase'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari tugas...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                onChanged: (val) => taskProvider.setSearchQuery(val),
              ),
            ),
            Expanded(
              child: taskProvider.tasks.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 100),
                        Center(child: Text('Tugas tidak ditemukan.')),
                      ],
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        bool isWide = constraints.maxWidth >= 600;

                        if (isWide) {
                          return GridView.builder(
                            padding: const EdgeInsets.all(16),
                            physics: const AlwaysScrollableScrollPhysics(),
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
                                onToggle: () async {
                                  await taskProvider.toggleTaskCompletion(task.id!);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          task.isCompleted
                                              ? 'Tugas ditandai belum selesai'
                                              : 'Selamat! Tugas telah selesai 🎉',
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          physics: const AlwaysScrollableScrollPhysics(),
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
                              onToggle: () async {
                                await taskProvider.toggleTaskCompletion(task.id!);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        task.isCompleted
                                            ? 'Tugas ditandai belum selesai'
                                            : 'Selamat! Tugas telah selesai 🎉',
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}