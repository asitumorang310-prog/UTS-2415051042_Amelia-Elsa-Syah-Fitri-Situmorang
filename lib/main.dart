import 'package:flutter/material.dart';
import 'priority_badge.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String category;
  final String dueDate;
  final String priority;
  final bool isCompleted;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const TaskCard({
    super.key,
    required this.title,
    required this.category,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: IconButton(
          icon: Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted ? Colors.green : Colors.grey,
            size: 26,
          ),
          onPressed: onToggle,
          tooltip: isCompleted ? 'Tandai Belum Selesai' : 'Tandai Selesai',
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('$category • $dueDate'),
        trailing: PriorityBadge(priority: priority),
      ),
    );
  }
}