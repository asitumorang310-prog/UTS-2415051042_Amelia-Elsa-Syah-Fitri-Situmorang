import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/quote_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final quoteProvider = Provider.of<QuoteProvider>(context);
    final recentTasks = taskProvider.tasks.take(4).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskMate Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => quoteProvider.fetchQuote(),
            tooltip: 'Refresh Motivasi',
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
                const SizedBox(height: 16),

                // Card Integrasi REST API GET (Motivasi Harian)
                _buildQuoteCard(context, quoteProvider),

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

  Widget _buildQuoteCard(BuildContext context, QuoteProvider quoteProvider) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.format_quote, size: 20, color: Colors.indigo),
                SizedBox(width: 8),
                Text(
                  'Motivasi Harian (REST API)',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (quoteProvider.status == QuoteStatus.loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else if (quoteProvider.status == QuoteStatus.error)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Gagal memuat quote: ${quoteProvider.errorMessage}',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18),
                    onPressed: () => quoteProvider.fetchQuote(),
                  ),
                ],
              )
            else if (quoteProvider.quote != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"${quoteProvider.quote!.quote}"',
                    style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '— ${quoteProvider.quote!.author}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}