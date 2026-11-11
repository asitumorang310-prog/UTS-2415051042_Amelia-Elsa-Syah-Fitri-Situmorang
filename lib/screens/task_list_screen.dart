
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  static const Color primaryColor = Color(0xFF7779D5);
  static const Color backgroundColor = Color(0xFFF5F4FF);
  static const Color darkColor = Color(0xFF292943);
  static const Color mutedColor = Color(0xFF9999AA);

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.tasks;
    final completed = tasks.where((task) => task.isCompleted).length;

    return Scaffold(
      backgroundColor: backgroundColor,
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
          'My Tasks',
          style: TextStyle(
            color: darkColor,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => taskProvider.fetchTasksFromDatabase(),
            icon: const Icon(Icons.refresh_rounded),
            color: primaryColor,
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: () => taskProvider.fetchTasksFromDatabase(),
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stay organized, stay productive!',
                      style: TextStyle(
                        fontSize: 13,
                        color: mutedColor,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SUMMARY CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(21),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF6668C8),
                            Color(0xFF9294E8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.25),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'TOTAL TUGAS KAMU',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  '${tasks.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 38,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '$completed tugas berhasil diselesaikan',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(21),
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                              size: 33,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SEARCH
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.025),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) =>
                            taskProvider.setSearchQuery(value),
                        decoration: InputDecoration(
                          hintText: 'Cari tugas yang kamu inginkan...',
                          hintStyle: const TextStyle(
                            color: mutedColor,
                            fontSize: 12,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: primaryColor,
                            size: 22,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 17,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 23),

                    // TITLE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daftar Tugas',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: darkColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9E9FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${tasks.length} tugas',
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // TASK CONTENT
              Expanded(
                child: _buildBodyContent(context, taskProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // BODY CONTENT
  Widget _buildBodyContent(
    BuildContext context,
    TaskProvider taskProvider,
  ) {
    if (taskProvider.status == TaskStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      );
    }

    // ERROR
    if (taskProvider.status == TaskStatus.error) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 70),
          const Icon(
            Icons.cloud_off_rounded,
            color: Color(0xFFE57373),
            size: 65,
          ),
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'Gagal Menghubungkan Database',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: darkColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              taskProvider.errorMessage.isEmpty
                  ? 'Periksa koneksi internet dan coba kembali.'
                  : taskProvider.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: mutedColor,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () =>
                  taskProvider.fetchTasksFromDatabase(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    // EMPTY
    if (taskProvider.tasks.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 65),
          Icon(
            Icons.assignment_turned_in_rounded,
            color: primaryColor.withOpacity(0.65),
            size: 75,
          ),
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'Belum Ada Tugas',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: darkColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Yuk, tambahkan tugas pertamamu!',
              style: TextStyle(
                color: mutedColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      );
    }

    // TASK LIST
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        if (isWide) {
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 14,
            ),
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              return _buildTaskCard(
                context,
                taskProvider,
                index,
              );
            },
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 25),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: taskProvider.tasks.length,
          itemBuilder: (context, index) {
            return _buildTaskCard(
              context,
              taskProvider,
              index,
            );
          },
        );
      },
    );
  }

  // CUSTOM TASK CARD
  Widget _buildTaskCard(
    BuildContext context,
    TaskProvider taskProvider,
    int index,
  ) {
    final task = taskProvider.tasks[index];

    final priority = task.priority.toString();
    final isCompleted = task.isCompleted;

    final priorityColor = _getPriorityColor(priority);

    final formattedDate =
        '${task.dueDate.day.toString().padLeft(2, '0')}/'
        '${task.dueDate.month.toString().padLeft(2, '0')}/'
        '${task.dueDate.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: isCompleted
            ? const Color(0xFFF9F9FC)
            : Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFFE8E8F0)
              : const Color(0xFFECEBFA),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5555A0).withOpacity(0.055),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(21),
        child: InkWell(
          borderRadius: BorderRadius.circular(21),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/detail',
              arguments: task.id,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                // CHECKBOX

// CHECKBOX INTERAKTIF
InkWell(
  borderRadius: BorderRadius.circular(30),
  onTap: () async {
    final messenger = ScaffoldMessenger.of(context);
    final wasCompleted = task.isCompleted;

    try {
      final isNowCompleted =
          await taskProvider.toggleTaskCompletion(task.id!);

      if (!context.mounted) return;

      messenger.hideCurrentSnackBar();

      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: isNowCompleted
              ? const Color(0xFF319B60)
              : const Color(0xFF6668C8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              Icon(
                isNowCompleted
                    ? Icons.celebration_rounded
                    : Icons.refresh_rounded,
                color: Colors.white,
                size: 23,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isNowCompleted
                      ? 'Yeay! Tugas berhasil diselesaikan!'
                      : 'Status tugas dikembalikan menjadi aktif.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      messenger.hideCurrentSnackBar();

      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFE05260),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: const Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Gagal memperbarui tugas. Silakan coba lagi.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  },
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeInOut,
    width: 29,
    height: 29,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isCompleted
          ? const Color(0xFF7779D5)
          : Colors.white,
      border: Border.all(
        color: isCompleted
            ? const Color(0xFF7779D5)
            : const Color(0xFFD2D1E2),
        width: 2,
      ),
    ),
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isCompleted
          ? const Icon(
              Icons.check_rounded,
              key: ValueKey('checked'),
              color: Colors.white,
              size: 19,
            )
          : const SizedBox(
              key: ValueKey('unchecked'),
            ),
    ),
  ),
),

                // TASK INFORMATION
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isCompleted
                              ? mutedColor
                              : darkColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.folder_open_rounded,
                            size: 13,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              task.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: mutedColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.calendar_month_rounded,
                            size: 13,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: mutedColor,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // STATUS LABEL
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? const Color(0xFFE5F7EC)
                                  : priorityColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isCompleted
                                  ? 'SELESAI'
                                  : priority.toUpperCase(),
                              style: TextStyle(
                                color: isCompleted
                                    ? const Color(0xFF319B60)
                                    : priorityColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 5),

                // DETAIL ARROW
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: isCompleted
                      ? const Color(0xFFCCCCD5)
                      : primaryColor.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // PRIORITY COLORS
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'tinggi':
        return const Color(0xFFE66A75);

      case 'medium':
      case 'sedang':
        return const Color(0xFFE9A23B);

      case 'low':
      case 'rendah':
        return const Color(0xFF48A987);

      default:
        return primaryColor;
    }
  }
}
