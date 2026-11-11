TaskMate - Task Management Mobile Application

TaskMate adalah aplikasi mobile berbasis Flutter yang dikembangkan untuk memenuhi Ujian Tengah Semester (UTS) Mata Kuliah Pemrograman Mobile. Terintegrasi dengan REST API untuk motivasi harian, serta menggunakan Supabase sebagai backend database untuk manajemen tugas secara real-time.

👤 Identitas Mahasiswa

Nama: Amelia Elsa Syah Fitri Situmorang
NIM: 2415051042
Kelas: PTI 5B
Tema Project: TaskMate (Task Management & Productivity App)
URL GitHub Repository: https://github.com/asitumorang310-prog/UTS-2415051042_Amelia-Elsa-Syah-Fitri-Situmorang

✨ Fitur Utama

Manajemen Tugas (CRUD Lengkap):

Create: Menambahkan tugas baru dengan judul, kategori, prioritas, tenggat waktu, dan deskripsi ke database Supabase.
Read: Menampilkan daftar tugas dalam bentuk list/grid yang responsif.
Update: Mengubah detail tugas atau menandai status selesai (toggle completion).
Delete: Menghapus tugas dengan konfirmasi dialog (AlertDialog) yang aman.
Pencarian & Filter: Memudahkan pengguna mencari tugas berdasarkan judul atau kategori.
Daily Quote API Integration: Mengambil kutipan motivasi harian secara otomatis dari REST API publik.
Interactive Feedback: Dilengkapi dengan Pull-to-Refresh dan SnackBar informatif untuk setiap aksi pengguna.
Robust State Handling: Menangani Loading State, Error State (dengan tombol Coba Lagi / Retry), dan Empty State.

🛠️ Tech Stack & Dependencies

Framework: Flutter (Dart)
State Management: Provider (ChangeNotifier)
Backend Database: Supabase (supabase_flutter)
HTTP Client: http (untuk REST API)
Architecture: Clean Architecture pattern (models, services, repositories, providers, screens, widgets)

🌐 REST API yang Digunakan

DummyJSON Quotes API: https://dummyjson.com/quotes/random
Fungsi: Mengambil data kutipan motivasi acak untuk ditampilkan di halaman Dashboard / Home.

🗄️ Backend & Database (Supabase)
Platform: Supabase / PostgreSQL (https://zrzvmvbcavaivqismdto.supabase.co)
Tabel Utama: tasks
Struktur Field Tabel:
id (UUID, Primary Key)
title (Text, Not Null)
description (Text)
category (Text)
priority (Text)
due_date (Timestamp with time zone)
is_completed (Boolean)
created_at (Timestamp with time zone)

📁 Struktur Arsitektur Aplikasi

lib/
├── models/
│   ├── task_model.dart
│   └── quote_model.dart
├── services/
│   ├── supabase_service.dart
│   └── api_service.dart
├── repositories/
│   ├── task_repository.dart
│   └── quote_repository.dart
├── providers/
│   ├── task_provider.dart
│   └── quote_provider.dart
├── screens/
│   ├── main_navigation_screen.dart
│   ├── home_screen.dart
│   ├── task_list_screen.dart
│   ├── task_detail_screen.dart
│   ├── add_task_screen.dart
│   ├── edit_task_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── task_card.dart
│   └── priority_badge.dart
└── main.dart


📱 Daftar Screen Fungsional (≥ 6 Screen)

Home / Dashboard: Ringkasan statistik tugas dan kutipan motivasi harian.
Task List Screen: Menampilkan daftar seluruh tugas dengan fitur pencarian dan Pull-to-Refresh.
Task Detail Screen: Menampilkan informasi lengkap tugas, opsi ubah status, dan tombol hapus.
Add Task Screen: Form untuk menambahkan tugas baru dengan validasi input.
Edit Task Screen: Form untuk memperbarui data tugas yang sudah ada.
Profile Screen: Informasi profil pengguna dan rincian aplikasi.

🚀 Cara Menjalankan Project

Clone repository ini ke komputer lokal :
git clone https://github.com/asitumorang310-prog/UTS-2415051042_Amelia-Elsa-Syah-Fitri-Situmorang.git
Masuk ke direktori project:
cd uts_2415051042_amelia
Unduh seluruh dependencies Flutter:
flutter pub get
Jalankan aplikasi di emulator atau browser (Chrome):
flutter run
