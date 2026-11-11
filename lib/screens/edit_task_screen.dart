
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  static const Color primary = Color(0xFF6668C8);
  static const Color background = Color(0xFFF2F2FF);
  static const Color dark = Color(0xFF292943);

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskModel? currentTask;
  String _priority = 'Medium';
  DateTime? _dueDate;
  bool _isLoading = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    final taskId = args is String ? args : null;

    if (taskId == null || taskId.isEmpty) return;

    final provider = context.read<TaskProvider>();

    final matches = provider.tasks.where((t) => t.id == taskId);

    if (matches.isEmpty) return;

    currentTask = matches.first;

    _titleController.text = currentTask!.title;
    _categoryController.text = currentTask!.category;
    _descriptionController.text = currentTask!.description;
    _priority = currentTask!.priority;
    _dueDate = currentTask!.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primary,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      setState(() => _dueDate = selected);
    }
  }

  String get formattedDate {
    final date = _dueDate!;
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Color _priorityColor(String value) {
    switch (value) {
      case 'Low':
        return const Color(0xFF48A878);
      case 'High':
        return const Color(0xFFE66B75);
      default:
        return const Color(0xFFE9A34D);
    }
  }

  Future<void> _updateData() async {
    if (currentTask == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final updated = TaskModel(
      id: currentTask!.id,
      title: _titleController.text.trim(),
      category: _categoryController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      dueDate: _dueDate!,
      isCompleted: currentTask!.isCompleted,
    );

    try {
      await context.read<TaskProvider>().updateTask(
            currentTask!.id!,
            updated,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tugas berhasil diperbarui!'),
          backgroundColor: Color(0xFF48A878),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui tugas: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentTask == null) {
      return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          title: const Text('Edit Tugas'),
        ),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 55,
                color: primary,
              ),
              SizedBox(height: 12),
              Text(
                'Data tugas tidak ditemukan.',
                style: TextStyle(
                  color: dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Tugas',
          style: TextStyle(
            color: dark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6668C8),
                    Color(0xFF999AE9),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Update Your Task',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          'Perbarui informasi tugasmu '
                          'agar tetap terorganisir.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.edit_note_rounded,
                    color: Colors.white,
                    size: 55,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Edit Task Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),

            const SizedBox(height: 18),

            _label('Judul Tugas'),
            _input(
              controller: _titleController,
              hint: 'Masukkan judul tugas',
              icon: Icons.assignment_outlined,
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Judul tugas wajib diisi'
                      : null,
            ),

            const SizedBox(height: 18),

            _label('Mata Kuliah / Kategori'),
            _input(
              controller: _categoryController,
              hint: 'Masukkan kategori',
              icon: Icons.book_outlined,
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Kategori wajib diisi'
                      : null,
            ),

            const SizedBox(height: 22),

            _label('Prioritas Tugas'),
            const SizedBox(height: 10),

            Row(
              children: ['Low', 'Medium', 'High'].map((value) {
                final selected = _priority == value;
                final color = _priorityColor(value);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: GestureDetector(
                      onTap: () => setState(() => _priority = value),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: selected ? color : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: selected ? color : Colors.grey.shade200,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              value == 'Low'
                                  ? Icons.keyboard_arrow_down_rounded
                                  : value == 'High'
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.remove_rounded,
                              color: selected ? Colors.white : color,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              value,
                              style: TextStyle(
                                color: selected ? Colors.white : dark,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 22),

            _label('Deadline Tugas'),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tanggal pengumpulan',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.edit_calendar_outlined,
                      color: primary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            _label('Deskripsi Tugas'),
            _input(
              controller: _descriptionController,
              hint: 'Masukkan deskripsi tugas',
              icon: Icons.notes_rounded,
              maxLines: 4,
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: primary.withOpacity(0.6),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_rounded),
                          SizedBox(width: 10),
                          Text(
                            'Simpan Perubahan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 15),

            const Center(
              child: Text(
                'Keep your tasks organized ✨',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: dark,
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 13, color: dark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
        prefixIcon: Icon(icon, color: primary, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }
}
