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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late String _priority;
  late String taskId;
  late TaskModel currentTask;
  bool isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      taskId = args != null ? args as String : '1';
      final provider = Provider.of<TaskProvider>(context, listen: false);
      currentTask = provider.tasks.firstWhere(
        (t) => t.id == taskId,
        orElse: () => provider.tasks.first,
      );

      _titleController = TextEditingController(text: currentTask.title);
      _categoryController = TextEditingController(text: currentTask.category);
      _descriptionController = TextEditingController(text: currentTask.description);
      _priority = currentTask.priority;
      isInit = true;
    }
  }

  void _updateData() {
    if (_formKey.currentState!.validate()) {
      final updated = TaskModel(
        id: currentTask.id,
        title: _titleController.text,
        category: _categoryController.text,
        description: _descriptionController.text,
        priority: _priority,
        dueDate: currentTask.dueDate,
        isCompleted: currentTask.isCompleted,
      );

      Provider.of<TaskProvider>(context, listen: false).updateTask(currentTask.id!, updated);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perubahan berhasil diperbarui!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Tugas')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Mata Kuliah',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Prioritas',
                  border: OutlineInputBorder(),
                ),
                items: ['Low', 'Medium', 'High']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) => setState(() => _priority = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateData,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Perbarui Tugas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}