import 'package:flutter/material.dart'; // Import ini diperlukan untuk TextEditingController
import 'package:get/get.dart';
import 'package:smartsmashapp/app/data/service/api_service.dart';

class JuaraController extends GetxController {
  // Observables untuk menyimpan data juara, status loading, dan pesan error
  final RxList<dynamic> juaraList = <dynamic>[].obs; // Ini akan menjadi list yang difilter
  final RxBool isLoadingJuara = true.obs;
  final RxString errorMessageJuara = ''.obs;

  // List internal untuk menyimpan semua data juara yang diambil dari API (tidak difilter)
  List<dynamic> _allJuaraList = [];

  // TextEditingController untuk mengelola input teks pada search box di tampilan
  final TextEditingController searchInputController = TextEditingController();
  
  // Observable untuk query pencarian
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJuara(); // Panggil method untuk mengambil data juara saat controller diinisialisasi

    // Sinkronkan nilai initial searchQuery dengan searchInputController.
    searchInputController.text = searchQuery.value;

    // Dengarkan perubahan pada searchQuery dan panggil filterJuaraByName.
    // debounce membantu mencegah panggilan berlebihan ke filter saat pengguna mengetik cepat.
    debounce(searchQuery, (String query) {
      filterJuaraByName(query);
    }, time: const Duration(milliseconds: 300));

    // Tambahkan listener untuk memantau perubahan pada searchInputController
    // dan memperbarui searchQuery. Ini akan memicu debounce di atas.
    searchInputController.addListener(() {
      if (searchQuery.value != searchInputController.text) {
        searchQuery.value = searchInputController.text;
      }
    });
  }

  // Method untuk mengambil data juara dari API
  Future<void> fetchJuara() async {
    isLoadingJuara.value = true;
    errorMessageJuara.value = ''; // Reset pesan error
    try {
      final response = await ApiService.getJuara();
      if (response['success']) {
        _allJuaraList = response['data'] ?? []; // Simpan semua data ke list internal
        filterJuaraByName(searchQuery.value); // Terapkan filter awal jika ada query

        if (_allJuaraList.isEmpty) { // Cek terhadap allJuaraList untuk status data awal
          errorMessageJuara.value = 'Tidak ada data juara yang ditemukan.';
        }
      } else {
        errorMessageJuara.value = response['message'] ?? 'Gagal mengambil data juara.';
      }
    } catch (e) {
      errorMessageJuara.value = 'Terjadi kesalahan: ${e.toString()}';
      print('Error fetching juara: ${e.toString()}'); // Log error untuk debugging
    } finally {
      isLoadingJuara.value = false;
    }
  }

  // Method untuk memfilter daftar juara berdasarkan nama
  void filterJuaraByName(String query) {
    if (query.isEmpty) {
      juaraList.assignAll(_allJuaraList); // Jika query kosong, tampilkan semua
    } else {
      final lowerCaseQuery = query.toLowerCase();
      juaraList.assignAll(
        _allJuaraList.where((juara) {
          final namaJuara = juara['nama']?.toLowerCase() ?? ''; // Pastikan kunci 'nama' ada dan ubah ke lowercase
          return namaJuara.contains(lowerCaseQuery);
        }).toList(),
      );
    }
    // Logika pesan kesalahan yang lebih robust untuk pencarian
    if (_allJuaraList.isEmpty) {
      errorMessageJuara.value = 'Belum ada data juara tersedia.';
    } else if (juaraList.isEmpty && query.isNotEmpty) {
      errorMessageJuara.value = 'Tidak ada juara yang ditemukan dengan nama "$query".';
    } else {
      errorMessageJuara.value = ''; // Hapus pesan error jika ada hasil
    }
  }

  // Method opsional untuk me-refresh data juara secara manual
  Future<void> refreshJuara() async {
    // Clear search query and text field on refresh
    searchQuery.value = '';
    searchInputController.clear();
    await fetchJuara();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    searchInputController.dispose(); // Pastikan controller di-dispose
    super.onClose();
  }
}
