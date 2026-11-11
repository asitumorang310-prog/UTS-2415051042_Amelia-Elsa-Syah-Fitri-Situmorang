
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/quote_provider.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryColor = Color(0xFF6668C8);
  static const Color backgroundColor = Color(0xFFF5F4FF);
  static const Color darkColor = Color(0xFF292943);
  static const Color mutedColor = Color(0xFF9999AA);

  // OPEN ADD TASK
  void _openAddTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    );
  }

  // NOTIFICATION CENTER
  void _showNotifications(
    BuildContext context,
    TaskProvider provider,
  ) {
    final pending = provider.tasks
        .where((task) => !task.isCompleted)
        .length;

    final highPriority = provider.tasks.where((task) {
      return !task.isCompleted &&
          task.priority.toString().toLowerCase() == 'high';
    }).length;

    final completed = provider.tasks
        .where((task) => task.isCompleted)
        .length;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 15, 22, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4E4EC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9E9FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notification Center',
                          style: TextStyle(
                            color: darkColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Ringkasan aktivitas tugasmu',
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              _notificationItem(
                Icons.assignment_outlined,
                'Tugas belum selesai',
                '$pending tugas masih menunggu untuk dikerjakan.',
                const Color(0xFFE9E9FF),
                primaryColor,
              ),

              const SizedBox(height: 12),

              _notificationItem(
                Icons.local_fire_department_rounded,
                'Prioritas tinggi',
                '$highPriority tugas memiliki prioritas tinggi.',
                const Color(0xFFFFE9E9),
                const Color(0xFFE66A75),
              ),

              const SizedBox(height: 12),

              _notificationItem(
                Icons.check_circle_rounded,
                'Tugas diselesaikan',
                '$completed tugas berhasil kamu selesaikan.',
                const Color(0xFFE1F4EA),
                const Color(0xFF48A878),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/tasks');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Lihat Semua Tugas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final quoteProvider = context.watch<QuoteProvider>();

    final quoteText = quoteProvider.quote?.quote ??
        'Tetap semangat menyelesaikan tugas harimu!';

    final highPriorityCount = taskProvider.tasks.where((task) {
      return !task.isCompleted &&
          task.priority.toString().toLowerCase() == 'high';
    }).length;

    final pendingCount = taskProvider.pendingCount;
    final totalCount = taskProvider.totalCount;
    final completedCount = taskProvider.completedCount;

    final progress = totalCount == 0
        ? 0.0
        : completedCount / totalCount;

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =========================
              // HEADER
              // =========================

              Row(
                children: [
                  Container(
                    width: 51,
                    height: 51,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFD8E8),
                          Color(0xFFFFECF3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(17),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE8A5C1)
                              .withOpacity(0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.school_rounded,
                          color: Color(0xFF9C4670),
                          size: 29,
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            size: 11,
                            color: Color(0xFFCF79A1),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Amelia!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: darkColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Make your day peaceful by finishing your tasks ✨',
                          style: TextStyle(
                            fontSize: 11,
                            color: mutedColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // NOTIFICATION
                  _headerButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: () => _showNotifications(
                      context,
                      taskProvider,
                    ),
                    badgeCount: pendingCount,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // =========================
              // GREETING
              // =========================

              const Text(
                'MAKE TODAY',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'A productive\nstudent day.',
                style: TextStyle(
                  fontSize: 31,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                  color: darkColor,
                ),
              ),

              const SizedBox(height: 9),

              const Text(
                'Atur tugas kuliahmu, selesaikan satu per satu, '
                'dan capai targetmu.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.6,
                  color: mutedColor,
                ),
              ),

              const SizedBox(height: 21),

              // =========================
              // CREATE TASK BUTTON
              // =========================

              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(19),
                child: InkWell(
                  onTap: () => _openAddTask(context),
                  borderRadius: BorderRadius.circular(19),
                  child: Ink(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 17,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF6264C6),
                          Color(0xFF898BE0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(19),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.23),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(
                            Icons.add_task_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),

                        const SizedBox(width: 13),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Buat Tugas Baru',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tambahkan tugas kuliahmu sekarang',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 21,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              // =========================
              // STATISTICS
              // =========================

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: darkColor,
                      letterSpacing: -0.4,
                    ),
                  ),
                  Text(
                    '$totalCount Tasks',
                    style: const TextStyle(
                      fontSize: 10,
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 13),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.85,
                children: [
                  _buildStatCard(
                    'Total Tugas',
                    '$totalCount',
                    Icons.assignment_rounded,
                    const Color(0xFFE9E9FF),
                    primaryColor,
                  ),
                  _buildStatCard(
                    'Selesai',
                    '$completedCount',
                    Icons.check_circle_rounded,
                    const Color(0xFFE1F4EA),
                    const Color(0xFF48A878),
                  ),
                  _buildStatCard(
                    'Tertunda',
                    '$pendingCount',
                    Icons.schedule_rounded,
                    const Color(0xFFFFEEDC),
                    const Color(0xFFE9A34D),
                  ),
                  _buildStatCard(
                    'Prioritas Tinggi',
                    '$highPriorityCount',
                    Icons.local_fire_department_rounded,
                    const Color(0xFFFFE9E9),
                    const Color(0xFFE66A75),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // =========================
              // PROGRESS
              // =========================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.insights_rounded,
                          color: primaryColor,
                          size: 22,
                        ),
                        const SizedBox(width: 9),
                        const Expanded(
                          child: Text(
                            'Task Progress',
                            style: TextStyle(
                              color: darkColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 9,
                        backgroundColor: const Color(0xFFEDEDF5),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                          primaryColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      totalCount == 0
                          ? 'Belum ada tugas. Yuk mulai produktif!'
                          : '$completedCount dari $totalCount tugas sudah selesai.',
                      style: const TextStyle(
                        color: mutedColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // =========================
              // DAILY MOTIVATION
              // =========================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7779D5),
                      Color(0xFF999AE9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(21),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.format_quote_rounded,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DAILY MOTIVATION',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                              letterSpacing: 1.4,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            quoteText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // RECENT TASKS
              // =========================

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tugas Terbaru',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: darkColor,
                      letterSpacing: -0.4,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/tasks');
                    },
                    child: const Text(
                      'Lihat Semua →',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              if (taskProvider.tasks.isEmpty)
                _buildEmptyTasks(context)
              else
                ...taskProvider.tasks.take(3).map((task) {
                  return _buildTaskCard(
                    context,
                    taskProvider,
                    task,
                  );
                }),

              const SizedBox(height: 15),

              // =========================
              // STUDENT FOOTER
              // =========================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAFF),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.school_rounded,
                      color: primaryColor,
                      size: 27,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Keep Learning, Keep Growing!',
                            style: TextStyle(
                              color: darkColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'One task at a time. You can do it!',
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // HEADER BUTTON
  static Widget _headerButton({
    required IconData icon,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 9,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: darkColor,
              size: 22,
            ),
            if (badgeCount > 0)
              Positioned(
                right: 6,
                top: 5,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE66A75),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // NOTIFICATION ITEM
  static Widget _notificationItem(
    IconData icon,
    String title,
    String subtitle,
    Color bgColor,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: darkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: mutedColor,
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // STATISTIC CARD
  static Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color bgColor,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    color: darkColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: mutedColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // EMPTY TASKS
  static Widget _buildEmptyTasks(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Color(0xFFE9E9FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_add,
              color: primaryColor,
              size: 29,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Belum Ada Tugas',
            style: TextStyle(
              color: darkColor,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Yuk, tambahkan tugas pertamamu!',
            style: TextStyle(
              color: mutedColor,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTaskScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Tambah Tugas'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // RECENT TASK CARD
  static Widget _buildTaskCard(
    BuildContext context,
    TaskProvider provider,
    dynamic task,
  ) {
    final isCompleted = task.isCompleted;

    final priority = task.priority.toString().toLowerCase();

    final priorityColor = priority == 'high'
        ? const Color(0xFFE66A75)
        : priority == 'low'
            ? const Color(0xFF48A878)
            : const Color(0xFFE9A34D);

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEDECF7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/detail',
              arguments: task.id,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    provider.toggleTaskCompletion(task.id!);
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? const Color(0xFFE1F4EA)
                          : const Color(0xFFE9E9FF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCompleted
                          ? Icons.check_rounded
                          : Icons.circle_outlined,
                      color: isCompleted
                          ? const Color(0xFF48A878)
                          : primaryColor,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: darkColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${task.category} • '
                        '${task.dueDate.day}/'
                        '${task.dueDate.month}/'
                        '${task.dueDate.year}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: mutedColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 7),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFFE1F4EA)
                        : priorityColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    isCompleted ? 'DONE' : priority.toUpperCase(),
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: isCompleted
                          ? const Color(0xFF48A878)
                          : priorityColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
