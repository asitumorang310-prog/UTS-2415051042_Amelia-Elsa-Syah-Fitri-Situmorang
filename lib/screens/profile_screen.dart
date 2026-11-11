
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/task_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color primaryColor = Color(0xFF6668C8);
  static const Color backgroundColor = Color(0xFFF5F4FF);
  static const Color darkColor = Color(0xFF292943);

  static const Color highColor = Color(0xFFE66A75);
  static const Color mediumColor = Color(0xFFE9A23B);
  static const Color lowColor = Color(0xFF48A987);

  String name = 'Amelia Elsa Syah Fitri Situmorang';
  String nim = '2415051042';
  String studyProgram = 'Pendidikan Teknik Informatika';
  String university = 'Universitas Pendidikan Ganesha';

  String get initials {
    final words = name.trim().split(RegExp(r'\s+'));

    if (words.isEmpty || words.first.isEmpty) return 'AS';

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }

    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  // EDIT PROFILE
  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: name);
    final nimController = TextEditingController(text: nim);
    final studyController = TextEditingController(text: studyProgram);
    final universityController = TextEditingController(text: university);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              color: darkColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _editField(
                  nameController,
                  'Nama Lengkap',
                  Icons.person_outline,
                ),
                const SizedBox(height: 13),
                _editField(
                  nimController,
                  'Nomor Induk Mahasiswa',
                  Icons.badge_outlined,
                ),
                const SizedBox(height: 13),
                _editField(
                  studyController,
                  'Program Studi',
                  Icons.school_outlined,
                ),
                const SizedBox(height: 13),
                _editField(
                  universityController,
                  'Universitas',
                  Icons.account_balance_outlined,
                ),
              ],
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
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    nimController.text.trim().isEmpty ||
                    studyController.text.trim().isEmpty ||
                    universityController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Semua informasi harus diisi!'),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext, {
                  'name': nameController.text.trim(),
                  'nim': nimController.text.trim(),
                  'study': studyController.text.trim(),
                  'university': universityController.text.trim(),
                });
              },
              child: const Text(
                'Simpan Perubahan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    nimController.dispose();
    studyController.dispose();
    universityController.dispose();

    if (!mounted || result == null) return;

    setState(() {
      name = result['name']!;
      nim = result['nim']!;
      studyProgram = result['study']!;
      university = result['university']!;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil diperbarui!'),
        backgroundColor: Color(0xFF48A878),
      ),
    );
  }

  Widget _editField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // PRIORITY CHECK
  String _getPriority(dynamic priority) {
    final value = priority.toString().toLowerCase();

    if (value.contains('high') || value.contains('tinggi')) {
      return 'high';
    }

    if (value.contains('medium') || value.contains('sedang')) {
      return 'medium';
    }

    if (value.contains('low') || value.contains('rendah')) {
      return 'low';
    }

    return 'other';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    final total = provider.tasks.length;

    final completed =
        provider.tasks.where((task) => task.isCompleted).length;

    final pending = total - completed;

    final progress = total == 0 ? 0.0 : completed / total;
    final percentage = (progress * 100).round();

    // MENGHITUNG PRIORITAS TUGAS YANG SELESAI
    final highCompleted = provider.tasks.where((task) =>
        task.isCompleted && _getPriority(task.priority) == 'high').length;

    final mediumCompleted = provider.tasks.where((task) =>
        task.isCompleted && _getPriority(task.priority) == 'medium').length;

    final lowCompleted = provider.tasks.where((task) =>
        task.isCompleted && _getPriority(task.priority) == 'low').length;

    final otherCompleted = provider.tasks.where((task) =>
        task.isCompleted && _getPriority(task.priority) == 'other').length;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: darkColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // PROFILE HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6668C8),
                      Color(0xFF999AE9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.23),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -25,
                      top: -35,
                      child: _circleDecoration(125),
                    ),
                    Positioned(
                      right: 35,
                      bottom: -55,
                      child: _circleDecoration(110),
                    ),

                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white70,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 43,
                            backgroundColor: const Color(0xFFFFD6E5),
                            child: Text(
                              initials,
                              style: const TextStyle(
                                color: Color(0xFF9C4670),
                                fontSize: 29,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 9),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'STUDENT DEVELOPER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              letterSpacing: 1.3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.badge_outlined,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              nim,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          studyProgram,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          university,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _editProfile,
                            icon: const Icon(
                              Icons.edit_rounded,
                              size: 16,
                            ),
                            label: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Colors.white70,
                              ),
                              backgroundColor:
                                  Colors.white.withOpacity(0.12),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // MY ACTIVITY
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Activity',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9E9FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'LIVE OVERVIEW',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              const Text(
                'Pantau perkembangan produktivitasmu.',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 16),

              // TASK PERFORMANCE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    // HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Task Performance',
                              style: TextStyle(
                                color: darkColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Your productivity overview',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9E9FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.auto_graph_rounded,
                                size: 13,
                                color: primaryColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'PROGRESS',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // MULTI COLOR DONUT CHART
                    SizedBox(
                      height: 190,
                      width: 190,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(190, 190),
                            painter: DonutChartPainter(
                              total: total,
                              highCount: highCompleted,
                              mediumCount: mediumCompleted,
                              lowCount: lowCompleted,
                              otherCount: otherCompleted,
                            ),
                          ),

                          // CENTER CIRCLE
                          Container(
                            width: 132,
                            height: 132,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFAFAFF),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.06),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$percentage%',
                                  style: const TextStyle(
                                    color: darkColor,
                                    fontSize: 31,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  'COMPLETED',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: 35,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      total == 0
                          ? 'Belum ada tugas dibuat.'
                          : '$completed dari $total tugas berhasil diselesaikan',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: darkColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      pending == 0 && total > 0
                          ? 'Hebat! Semua tugas sudah selesai.'
                          : '$pending tugas masih perlu diselesaikan',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Divider(
                      color: Color(0xFFF0F0F5),
                      thickness: 1,
                    ),

                    const SizedBox(height: 14),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Completed by Priority',
                        style: TextStyle(
                          color: darkColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _buildPriorityItem(
                            'High',
                            highCompleted,
                            highColor,
                          ),
                        ),
                        Expanded(
                          child: _buildPriorityItem(
                            'Medium',
                            mediumCompleted,
                            mediumColor,
                          ),
                        ),
                        Expanded(
                          child: _buildPriorityItem(
                            'Low',
                            lowCompleted,
                            lowColor,
                          ),
                        ),
                      ],
                    ),

                    if (otherCompleted > 0) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _buildPriorityItem(
                          'Other',
                          otherCompleted,
                          primaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // STATISTIC CARDS
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total',
                      '$total',
                      Icons.assignment_rounded,
                      const Color(0xFFE9E9FF),
                      primaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      'Selesai',
                      '$completed',
                      Icons.check_circle_rounded,
                      const Color(0xFFE1F4EA),
                      const Color(0xFF48A878),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      'Aktif',
                      '$pending',
                      Icons.hourglass_bottom_rounded,
                      const Color(0xFFFFEEDC),
                      const Color(0xFFE9A34D),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // PERSONAL INFORMATION
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: darkColor,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Informasi identitas akun kamu.',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: _whiteCard(),
                child: Column(
                  children: [
                    _buildInfoTile(
                      Icons.person_outline_rounded,
                      'Nama Lengkap',
                      name,
                    ),
                    _buildDivider(),
                    _buildInfoTile(
                      Icons.badge_outlined,
                      'Nomor Induk Mahasiswa',
                      nim,
                    ),
                    _buildDivider(),
                    _buildInfoTile(
                      Icons.school_outlined,
                      'Program Studi',
                      studyProgram,
                    ),
                    _buildDivider(),
                    _buildInfoTile(
                      Icons.account_balance_outlined,
                      'Universitas',
                      university,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ABOUT TASKMATE
              const Text(
                'About TaskMate',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: darkColor,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Teknologi yang digunakan dalam aplikasi.',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(17),
                decoration: _whiteCard(),
                child: Column(
                  children: [
                    _buildProjectTile(
                      Icons.phone_android_rounded,
                      'Mobile Development',
                      'Flutter SDK dan Dart',
                    ),
                    _buildDivider(),
                    _buildProjectTile(
                      Icons.widgets_outlined,
                      'State Management',
                      'Provider',
                    ),
                    _buildDivider(),
                    _buildProjectTile(
                      Icons.storage_rounded,
                      'Database',
                      'Supabase Database',
                    ),
                    _buildDivider(),
                    _buildProjectTile(
                      Icons.cloud_outlined,
                      'External API',
                      'REST API Quotes',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // APP INFORMATION
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE5E6FF),
                      Color(0xFFF0EFFF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: const Icon(
                        Icons.task_alt_rounded,
                        size: 32,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'TaskMate',
                      style: TextStyle(
                        color: darkColor,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Organize Your Tasks, Achieve Your Goals.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF77778E),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'VERSION 1.0 • UTS 2026',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // FOOTER
              const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFFE78BAF),
                      size: 20,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Designed & Developed by Amelia',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'TaskMate Mobile Application © 2026',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
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

  // DECORATION CIRCLE
  Widget _circleDecoration(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
    );
  }

  // PRIORITY LEGEND
  Widget _buildPriorityItem(
    String label,
    int count,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$count Tasks',
                style: const TextStyle(
                  color: darkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // STATISTIC CARD
  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color bgColor,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: _whiteCard(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
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
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: darkColor,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // PERSONAL INFORMATION
  Widget _buildInfoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _iconBox(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: darkColor,
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

  // PROJECT INFORMATION
  Widget _buildProjectTile(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          _iconBox(icon),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: darkColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF48A878),
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      width: 39,
      height: 39,
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: primaryColor,
        size: 19,
      ),
    );
  }

  BoxDecoration _whiteCard() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.025),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.6,
      color: Color(0xFFF0F0F5),
    );
  }
}

// CUSTOM PAINTER - MULTI COLOR PRIORITY DONUT
class DonutChartPainter extends CustomPainter {
  final int total;
  final int highCount;
  final int mediumCount;
  final int lowCount;
  final int otherCount;

  DonutChartPainter({
    required this.total,
    required this.highCount,
    required this.mediumCount,
    required this.lowCount,
    required this.otherCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        math.min(size.width / 2, size.height / 2) - 13;

    const strokeWidth = 17.0;

    // BACKGROUND TRACK
    final backgroundPaint = Paint()
      ..color = const Color(0xFFECEBFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );

    if (total == 0) return;

    // PRIORITY SEGMENTS
    final segments = [
      (count: highCount, color: const Color(0xFFE66A75)),
      (count: mediumCount, color: const Color(0xFFE9A23B)),
      (count: lowCount, color: const Color(0xFF48A987)),
      (count: otherCount, color: const Color(0xFF7779D5)),
    ];

    double startAngle = -math.pi / 2;

    for (final segment in segments) {
      if (segment.count <= 0) continue;

      final sweepAngle =
          2 * math.pi * segment.count / total;

      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true;

      final gap = sweepAngle > 0.08 ? 0.035 : 0.0;

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        startAngle,
        math.max(0.0, sweepAngle - gap),
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(
    covariant DonutChartPainter oldDelegate,
  ) {
    return oldDelegate.total != total ||
        oldDelegate.highCount != highCount ||
        oldDelegate.mediumCount != mediumCount ||
        oldDelegate.lowCount != lowCount ||
        oldDelegate.otherCount != otherCount;
  }
}
