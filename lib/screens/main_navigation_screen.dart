import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'task_list_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  static const Color primary = Color(0xFF6668C8);
  static const Color background = Color(0xFFF2F2FF);
  static const Color darkColor = Color(0xFF292943);

  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    TaskListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        if (isWide) {
          return Scaffold(
            backgroundColor: background,
            body: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x10000000),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: NavigationRail(
                    backgroundColor: Colors.white,
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (index) {
                      setState(() => _selectedIndex = index);
                    },
                    labelType: NavigationRailLabelType.all,
                    indicatorColor: const Color(0xFFE9E9FF),
                    selectedIconTheme: const IconThemeData(
                      color: primary,
                      size: 25,
                    ),
                    unselectedIconTheme: const IconThemeData(
                      color: Colors.grey,
                      size: 23,
                    ),
                    selectedLabelTextStyle: const TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                    unselectedLabelTextStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF6668C8),
                              Color(0xFF999AE9),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.task_alt_rounded,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                    ),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.dashboard_outlined),
                        selectedIcon: Icon(Icons.dashboard_rounded),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.task_outlined),
                        selectedIcon: Icon(Icons.task_rounded),
                        label: Text('Tasks'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_outline_rounded),
                        selectedIcon: Icon(Icons.person_rounded),
                        label: Text('Profile'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _screens,
                  ),
                ),
              ],
            ),
          );
        }

        // TAMPILAN HP (MOBILE) DENGAN CUSTOM BOTTOM BAR YANG CANTIK & RAPAT
        return Scaffold(
          backgroundColor: background,
          body: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: Container(
            height: 68,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.dashboard_outlined, Icons.dashboard_rounded, 'Home'),
                _buildNavItem(1, Icons.task_outlined, Icons.task_rounded, 'Tasks'),
                _buildNavItem(2, Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        );
      },
    );
  }

  // WIDGET TOMBOL NAVIGASI CUSTOM YANG ELEGAN
  Widget _buildNavItem(int index, IconData iconOutlined, IconData iconRounded, String label) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 18 : 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF0FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? iconRounded : iconOutlined,
              color: isSelected ? primary : Colors.grey[400],
              size: 21,
            ),
            if (isSelected) ...[
              const SizedBox(width: 7),
              Text(
                label,
                style: const TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}