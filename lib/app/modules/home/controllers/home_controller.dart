import 'package:flutter/material.dart'; // Import ini sudah ada dan dipastikan ada
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:smartsmashapp/app/data/service/api_service.dart';
import 'package:smartsmashapp/app/modules/camera/views/camera_view.dart';
import 'package:smartsmashapp/app/modules/grafik/views/grafik_view.dart';
import 'package:smartsmashapp/app/modules/home/views/home_view.dart';
import 'package:smartsmashapp/app/modules/materi/views/materi_view.dart';
import 'package:smartsmashapp/app/modules/profile/views/profile_view.dart';

class HomeController extends GetxController {
  // Index navigasi BottomNavigationBar
  final RxInt selectedIndex = 0.obs;

  // Nama user untuk ditampilkan di UI
  final RxString namaUser = 'User'.obs;

  // Observable untuk daftar pelatih
  // pelatihList saat ini tidak lagi digunakan secara langsung untuk tampilan,
  // melainkan untuk debugging atau jika diperlukan kembali di masa depan.
  final RxList<Map<String, dynamic>> pelatihList = <Map<String, dynamic>>[].obs;

  // Observable untuk status loading pelatih
  final RxBool isLoadingPelatih = true.obs;
  // Observable untuk pesan error pelatih
  final RxString errorMessagePelatih = ''.obs;

  // List internal untuk menyimpan semua data pelatih yang diambil dari API (tidak difilter)
  // Ini adalah sumber data utama sebelum difilter.
  List<Map<String, dynamic>> _allPelatihList = [];

  // Observable untuk query pencarian
  // Nilai ini diubah oleh TextField di HomeView dan memicu pemfilteran.
  final RxString searchQuery = ''.obs;

  // Observable untuk daftar pelatih yang difilter
  // List ini yang akan ditampilkan di UI HomeView.
  final RxList<Map<String, dynamic>> filteredPelatihList =
      <Map<String, dynamic>>[].obs;

  // TextEditingController untuk mengelola input teks pada search box di HomeView.
  // Dikelola di sini untuk memastikan siklus hidup yang benar dengan GetX.
  final TextEditingController searchInputController = TextEditingController();

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

  // Daftar halaman untuk setiap tab BottomNavigationBar
  final List<Widget> pages = [
    const HomeView(),
    const GrafikView(),
    const CameraView(),
    const MateriView(),
    ProfileView(),
  ];

  // Mengubah tab yang dipilih di BottomNavigationBar
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
      final result = await ApiService.getProfile();

      debugPrint('✅ Full profile response: $result');

      // Pastikan respons sukses dan memiliki data pengguna
      if (result['success'] == true && result['data'] is Map<String, dynamic>) {
        final userData = result['data'] as Map<String, dynamic>;
        // Mengakses 'nama' karena app.py sekarang mengembalikan 'nama'
        var nama = userData['nama'];

        if (nama != null && nama.toString().trim().isNotEmpty) {
          namaUser.value = nama.toString();
          debugPrint('✅ Nama user ditemukan: ${namaUser.value}');
        } else {
          debugPrint(
            '⚠️ Nama tidak ditemukan atau kosong di data pengguna, pakai default',
          );
          namaUser.value = 'User';
        }
      } else {
        debugPrint(
          '⚠️ Gagal mengambil profil user atau format data tidak sesuai: ${result['message']}',
        );
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
      greetingIcon = LucideIcons.sun; // Ikon matahari untuk pagi
    } else if (hour >= 10 && hour < 15) {
      greetingText = 'Selamat Siang';
      greetingIcon = LucideIcons.cloudSun; // Ikon matahari & awan untuk siang
    } else if (hour >= 15 && hour < 18) {
      greetingText = 'Selamat Sore';
      greetingIcon = LucideIcons.cloudy; // Ikon berawan untuk sore
    } else {
      greetingText = 'Selamat Malam';
      greetingIcon = LucideIcons.moon; // Ikon bulan untuk malam
    }

    return {'text': greetingText, 'icon': greetingIcon};
  }

  // Fungsi untuk mengambil data pelatih dari API
  Future<void> fetchPelatih() async {
    isLoadingPelatih.value = true;
    errorMessagePelatih.value = '';
    try {
      final result = await ApiService.getPelatih();
      if (result['success']) {
        final List<dynamic> data = result['data'];
        _allPelatihList =
            data.cast<Map<String, dynamic>>(); // Simpan semua data
        filterPelatihByName(
          searchQuery.value,
        ); // Terapkan filter awal jika ada query

        // Perbarui pelatihList (opsional, jika masih digunakan di tempat lain)
        pelatihList.assignAll(_allPelatihList);

        if (_allPelatihList.isEmpty) {
          // Periksa terhadap _allPelatihList untuk status data awal
          errorMessagePelatih.value = 'Belum ada data pelatih tersedia.';
        }
      } else {
        errorMessagePelatih.value =
            result['message'] ?? 'Gagal mengambil data pelatih.';
      }
    } catch (e) {
      errorMessagePelatih.value = 'Terjadi kesalahan jaringan: $e';
      debugPrint('Error fetching pelatih: $e'); // Debugging
    } finally {
      isLoadingPelatih.value = false;
    }
  }

  // Fungsi untuk memfilter daftar pelatih berdasarkan nama
  void filterPelatihByName(String query) {
    if (query.isEmpty) {
      filteredPelatihList.assignAll(_allPelatihList);
    } else {
      final lowerCaseQuery = query.toLowerCase();
      filteredPelatihList.assignAll(
        _allPelatihList.where((pelatih) {
          final namaPelatih = pelatih['nama']?.toLowerCase() ?? '';
          return namaPelatih.contains(lowerCaseQuery);
        }).toList(),
      );
    }
    // Logika pesan kesalahan yang lebih robust
    if (_allPelatihList.isEmpty) {
      errorMessagePelatih.value = 'Belum ada data pelatih tersedia.';
    } else if (filteredPelatihList.isEmpty && query.isNotEmpty) {
      errorMessagePelatih.value =
          'Tidak ada pelatih yang ditemukan dengan nama "$query".';
    } else {
      errorMessagePelatih.value = ''; // Hapus pesan error jika ada hasil
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUser(); // Panggil saat controller pertama kali dibuat
    fetchPelatih(); // Panggil untuk mengambil data pelatih

    // Sinkronkan nilai initial searchQuery dengan searchInputController.
    // Penting agar TextField menampilkan nilai yang benar saat pertama kali dimuat.
    searchInputController.text = searchQuery.value;

    // Dengarkan perubahan pada searchQuery dan panggil filterPelatihByName.
    // debounce membantu mencegah panggilan berlebihan ke filter saat pengguna mengetik cepat.
    debounce(searchQuery, (String query) {
      filterPelatihByName(query);
    }, time: const Duration(milliseconds: 300));

    // Tambahkan listener untuk memantau perubahan pada searchInputController
    // dan memperbarui searchQuery. Ini akan memicu debounce di atas.
    searchInputController.addListener(() {
      if (searchQuery.value != searchInputController.text) {
        searchQuery.value = searchInputController.text;
      }
    });
  }

  @override
  void onClose() {
    searchInputController
        .dispose(); // Pastikan controller di-dispose untuk mencegah kebocoran memori
    super.onClose();
  }
}
