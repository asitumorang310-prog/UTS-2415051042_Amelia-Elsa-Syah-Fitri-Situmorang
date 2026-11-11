
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

  static const Color primaryColor = Color(0xFF7779D5);
  static const Color darkColor = Color(0xFF292943);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFECEBFA),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // CHECKBOX
                InkWell(
                  onTap: onToggle,
                  borderRadius: BorderRadius.circular(30),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? const Color(0xFF7779D5)
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? primaryColor
                            : const Color(0xFFD1D1E2),
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 18,
                          )
                        : null,
                  ),
                ),

                const SizedBox(width: 15),

                // TASK INFORMATION
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isCompleted
                              ? Colors.grey
                              : darkColor,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),

                      const SizedBox(height: 9),

                      // CATEGORY
                      Row(
                        children: [
                          const Icon(
                            Icons.folder_open_rounded,
                            size: 14,
                            color: Color(0xFF9999B8),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF85859E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // DEADLINE
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 14,
                            color: isCompleted
                                ? Colors.grey
                                : primaryColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            dueDate,
                            style: TextStyle(
                              fontSize: 11,
                              color: isCompleted
                                  ? Colors.grey
                                  : const Color(0xFF77778F),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // PRIORITY BADGE
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PriorityBadge(priority: priority),
                    const SizedBox(height: 7),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
