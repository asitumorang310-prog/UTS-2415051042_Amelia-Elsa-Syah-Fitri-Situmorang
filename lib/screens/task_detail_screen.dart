
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/priority_badge.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  static const Color primaryColor = Color(0xFF6668C8);
  static const Color backgroundColor = Color(0xFFF2F2FF);
  static const Color darkColor = Color(0xFF292943);

  @override
  Widget build(BuildContext context) {
    final taskId = ModalRoute.of(context)?.settings.arguments as String?;
    final taskProvider = context.watch<TaskProvider>();

    if (taskId == null || taskId.isEmpty) {
      return _errorScreen(context, 'Tugas tidak ditemukan.');
    }

    final taskIndex =
        taskProvider.tasks.indexWhere((t) => t.id == taskId);

    if (taskIndex == -1) {
      return _errorScreen(context, 'Data tugas telah dihapus.');
    }

    final task = taskProvider.tasks[taskIndex];

    return Scaffold(
      backgroundColor: backgroundColor,

      // APP BAR
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: darkColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Tugas',
          style: TextStyle(
            color: darkColor,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            color: primaryColor,
            tooltip: 'Edit Tugas',
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/edit',
                arguments: task.id,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            color: Colors.redAccent,
            tooltip: 'Hapus Tugas',
            onPressed: () {
              _showDeleteDialog(context, taskProvider, task);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // MAIN TASK CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF7779D5),
                              Color(0xFF999AE9),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.18),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    task.isCompleted
                                        ? 'Selesai'
                                        : 'Sedang Dikerjakan',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.assignment_rounded,
                                  color: Colors.white70,
                                  size: 30,
                                ),
                              ],
                            ),

                            const SizedBox(height: 25),

                            const Text(
                              'TASK TITLE',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 25,
                                height: 1.3,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Colors.white,
                                  size: 17,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  'Deadline: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // INFORMATION TITLE
                      const Text(
                        'Informasi Tugas',
                        style: TextStyle(
                          color: darkColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // CATEGORY
                      _infoCard(
                        icon: Icons.folder_open_rounded,
                        title: 'Kategori',
                        child: Text(
                          task.category,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: darkColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // PRIORITY
                      _infoCard(
                        icon: Icons.flag_rounded,
                        title: 'Prioritas',
                        child: PriorityBadge(
                          priority: task.priority,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // DESCRIPTION
                      const Text(
                        'Deskripsi Tugas',
                        style: TextStyle(
                          color: darkColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.025),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          task.description.isEmpty
                              ? 'Belum ada deskripsi untuk tugas ini.'
                              : task.description,
                          style: const TextStyle(
                            color: Color(0xFF666677),
                            fontSize: 13,
                            height: 1.7,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // BOTTOM BUTTON
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    taskProvider.toggleTaskCompletion(task.id!);
                  },
                  icon: Icon(
                    task.isCompleted
                        ? Icons.undo_rounded
                        : Icons.check_circle_outline_rounded,
                  ),
                  label: Text(
                    task.isCompleted
                        ? 'Tandai Belum Selesai'
                        : 'Tandai Sebagai Selesai',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: task.isCompleted
                        ? const Color(0xFFE7E7F0)
                        : primaryColor,
                    foregroundColor: task.isCompleted
                        ? darkColor
                        : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // INFORMATION CARD
  static Widget _infoCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE9E9FF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 5),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  // DELETE CONFIRMATION
  void _showDeleteDialog(
    BuildContext context,
    TaskProvider taskProvider,
    dynamic task,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Hapus Tugas?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkColor,
            ),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus "${task.title}"?',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);

                try {
                  await taskProvider.deleteTask(task.id!);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tugas berhasil dihapus!'),
                        backgroundColor: Colors.green,
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
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // ERROR SCREEN
  Widget _errorScreen(BuildContext context, String message) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('Detail Tugas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.assignment_late_outlined,
              color: primaryColor,
              size: 65,
            ),
            const SizedBox(height: 15),
            Text(
              message,
              style: const TextStyle(
                color: darkColor,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
