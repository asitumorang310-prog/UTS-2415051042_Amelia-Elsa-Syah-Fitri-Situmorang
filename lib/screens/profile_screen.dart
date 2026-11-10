import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengembang'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Text(
                      'AS',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Amelia Elsa Syah Fitri Situmorang',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text('NIM: 2415051042', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  const Text('Pendidikan Teknik Informatika', style: TextStyle(color: Colors.grey)),
                  const Text('Universitas Pendidikan Ganesha', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Statistik Belajar TaskMate',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildProfileStatCard('Total Tugas', '${taskProvider.totalCount}', Icons.folder, Colors.blue),
                      ),
                      Expanded(
                        child: _buildProfileStatCard('Selesai', '${taskProvider.completedCount}', Icons.task_alt, Colors.green),
                      ),
                      Expanded(
                        child: _buildProfileStatCard('Aktif', '${taskProvider.pendingCount}', Icons.hourglass_bottom, Colors.orange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Informasi Proyek UTS',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: const [
                        ListTile(
                          leading: Icon(Icons.code, color: Colors.indigo),
                          title: Text('Teknologi'),
                          subtitle: Text('Flutter SDK • Dart • Provider State Management'),
                        ),
                        Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.storage, color: Colors.indigo),
                          title: Text('Backend & API'),
                          subtitle: Text('Supabase Database & REST API Quotes'),
                        ),
                        Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.school, color: Colors.indigo),
                          title: Text('Konsentrasi'),
                          subtitle: Text('Rekayasa Perangkat Lunak (RPL)'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'TaskMate Mobile App v1.0 • UTS 2026',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}