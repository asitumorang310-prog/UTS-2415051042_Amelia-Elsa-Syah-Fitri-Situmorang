import 'package:flutter/material.dart';
import 'priority_badge.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String category;
  final String dueDate;
  final String priority;
  final bool isCompleted;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.category,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? Colors.green : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('$category • Tenggat: $dueDate'),
        trailing: PriorityBadge(priority: priority),
      ),
    );
  }
}