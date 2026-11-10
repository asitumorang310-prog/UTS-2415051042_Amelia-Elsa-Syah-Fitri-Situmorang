import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final recentTasks = taskProvider.tasks.take(4).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskMate Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task),
            onPressed: () => Navigator.pushNamed(context, '/add'),
            tooltip: 'Tambah Tugas',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth >= 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Halo, Amelia! 👋',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Kelola tugas perkuliahanmu dengan teratur',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Belum Selesai',
                        value: taskProvider.pendingCount.toString(),
                        icon: Icons.pending_actions,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        title: 'Tugas Selesai',
                        value: taskProvider.completedCount.toString(),
                        icon: Icons.task_alt,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daftar Tugas Terbaru',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/tasks'),
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (recentTasks.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Belum ada tugas. Klik + untuk menambah!'),
                    ),
                  )
                else if (isWide)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: recentTasks.length,
                    itemBuilder: (context, index) {
                      final task = recentTasks[index];
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
                  )
                else
                  Column(
                    children: recentTasks.map((task) {
                      return TaskCard(
                        title: task.title,
                        category: task.category,
                        dueDate: "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}",
                        priority: task.priority,
                        isCompleted: task.isCompleted,
                        onTap: () => Navigator.pushNamed(context, '/detail', arguments: task.id),
                        onToggle: () => taskProvider.toggleTaskCompletion(task.id!),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        icon: const Icon(Icons.add),
        label: const Text('Tugas Baru'),
      ),
    );
  }
}