import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'package:smartsmashapp/app/data/service/api_service.dart';
import 'package:smartsmashapp/app/modules/camera/views/camera_view.dart';
import 'package:smartsmashapp/app/modules/grafik/views/grafik_view.dart';
import 'package:smartsmashapp/app/modules/home/views/home_view.dart';
import 'package:smartsmashapp/app/modules/materi/views/materi_view.dart';
import 'package:smartsmashapp/app/modules/profile/views/profile_view.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeController extends GetxController {
  // Index navigasi BottomNavigationBar
  final RxInt selectedIndex = 0.obs;

  // Nama user untuk ditampilkan di UI
  final RxString namaUser = 'User'.obs;

  // Item navigasi bawah (ikon & label)
  final List<Map<String, dynamic>> navItems = [
    {'icon': LucideIcons.home, 'label': 'Beranda'},
    {'icon': LucideIcons.pieChart, 'label': 'Grafik'},
    {'icon': LucideIcons.camera, 'label': 'Kamera'},
    {
      'icon':
          LucideIcons
              .youtube, // Or LucideIcons.fileText if 'Materi' refers to documents
      'label': 'Materi',
    },
    {
      'icon': LucideIcons.user, // Or LucideIcons.circleUser
      'label': 'Profil',
    },
  ];

  // Daftar halaman untuk setiap tab
  final List<Widget> pages = [
    const HomeView(),
    const GrafikView(),
    const CameraView(),
    const MateriView(),
    ProfileView(),
  ];

  // Mengubah tab yang dipilih
  void changePage(int index) {
    if (index >= 0 && index < pages.length) {
      selectedIndex.value = index;
    } else {
      debugPrint('⚠️ Index $index di luar jangkauan pages');
    }
  }

  // Ambil data user dari backend dan set namaUser
  Future<void> fetchUser() async {
    try {
      final profile = await ApiService.getProfile();

      debugPrint('✅ Full profile response: $profile');

      if (profile == null) {
        debugPrint('⚠️ Profile null: Token mungkin invalid/expired');
        namaUser.value = 'User';
        return;
      }

      if (profile is! Map) {
        debugPrint('⚠️ Profile bukan Map, tipe: ${profile.runtimeType}');
        namaUser.value = 'User';
        return;
      }

      // Cek jika nama ada langsung di level atas
      var nama = profile['nama'];

      // Jika nama null atau kosong, cek di dalam "data"
      if ((nama == null || nama.toString().trim().isEmpty) &&
          profile.containsKey('data')) {
        final data = profile['data'];
        if (data is Map) {
          nama = data['nama'];
        }
      }

      // Cek alternatif key lain, misal "user" atau "userName"
      if (nama == null || nama.toString().trim().isEmpty) {
        if (profile.containsKey('user') && profile['user'] is Map) {
          final userMap = profile['user'] as Map;
          nama = userMap['nama'] ?? userMap['userName'];
        }
      }

      if (nama != null && nama.toString().trim().isNotEmpty) {
        namaUser.value = nama.toString();
        debugPrint('✅ Nama user ditemukan: ${namaUser.value}');
      } else {
        debugPrint('⚠️ Nama tidak ditemukan atau kosong, pakai default');
        namaUser.value = 'User';
      }
    } catch (e, stack) {
      namaUser.value = 'User';
      debugPrint('❌ Error fetching user profile: $e');
      debugPrint('$stack');
    }
  }

  // Memberi sapaan dan mengembalikan ikon berdasarkan waktu (WIB)
  Map<String, dynamic> greetingByTime() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 7)); // WIB
    final hour = now.hour;

    String greetingText;
    IconData greetingIcon;

    if (hour >= 4 && hour < 10) {
      greetingText = 'Selamat Pagi';
      greetingIcon = Ionicons.sunny_outline; // Ikon matahari untuk pagi
    } else if (hour >= 10 && hour < 15) {
      greetingText = 'Selamat Siang';
      greetingIcon = Ionicons.sunny_outline; // Ikon matahari untuk siang
    } else if (hour >= 15 && hour < 18) {
      greetingText = 'Selamat Sore';
      greetingIcon = Ionicons.cloudy_night_outline; // Ikon sore (bisa diubah)
    } else {
      greetingText = 'Selamat Malam';
      greetingIcon = Ionicons.moon_outline; // Ikon bulan untuk malam
    }

    return {'text': greetingText, 'icon': greetingIcon};
  }

  @override
  void onInit() {
    super.onInit();
    fetchUser(); // Panggil saat controller pertama kali dibuat
  }
}
