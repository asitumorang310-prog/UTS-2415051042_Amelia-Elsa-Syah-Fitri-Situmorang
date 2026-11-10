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
            onPressed: () => taskProvider.fetchTasksFromDatabase(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => taskProvider.fetchTasksFromDatabase(),
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
              child: _buildBodyContent(context, taskProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, TaskProvider taskProvider) {
    // 1. Loading State (Tampilan saat fetching data dari Supabase)
    if (taskProvider.status == TaskStatus.loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Memuat data tugas dari Supabase...'),
          ],
        ),
      );
    }

    // 2. Error State (Tampilan saat gagal terhubung + Tombol Retry)
    if (taskProvider.status == TaskStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text(
                'Gagal Terhubung ke Database',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                taskProvider.errorMessage.isEmpty
                    ? 'Terjadi kesalahan pada server atau jaringan.'
                    : taskProvider.errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => taskProvider.fetchTasksFromDatabase(),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Empty State (Tampilan saat belum ada data)
    if (taskProvider.tasks.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 100),
          Center(
            child: Text(
              'Tugas tidak ditemukan.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      );
    }

    // 4. Loaded State (Tampilan saat data siap)
    return LayoutBuilder(
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
                onToggle: () => taskProvider.toggleTaskCompletion(task.id!),
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
              onToggle: () => taskProvider.toggleTaskCompletion(task.id!),
            );
          },
        );
      },
    );
  }
}