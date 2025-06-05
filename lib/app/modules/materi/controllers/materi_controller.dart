import 'package:get/get.dart';
import 'package:flutter/foundation.dart'; // Import untuk kDebugMode
import 'package:flutter/material.dart'; // Import untuk TextEditingController

// Pastikan jalur ini benar untuk ApiService Anda
// Sesuaikan dengan path sebenarnya di proyek Anda
import 'package:smartsmashapp/app/data/service/api_service.dart';

class MateriController extends GetxController {
  // Observable list untuk menyimpan data materi asli dari API
  // Data ini tidak akan diubah, hanya digunakan sebagai sumber untuk filter
  final RxList<Map<String, dynamic>> _allMateriList =
      <Map<String, dynamic>>[].obs;

  // Observable list untuk menyimpan data materi yang sudah difilter/dicari
  // List inilah yang akan ditampilkan di UI
  final RxList<Map<String, dynamic>> materiList = <Map<String, dynamic>>[].obs;

  // Observable boolean untuk menunjukkan status loading saat mengambil data
  final RxBool isLoading = true.obs;
  // Observable string untuk menyimpan pesan error jika terjadi kegagalan
  final RxString errorMessage = ''.obs;

  // RxString yang akan menampung nilai dari TextField pencarian.
  // Ini adalah properti reaktif yang kita dengarkan perubahannya.
  final RxString searchQuery = ''.obs;

  // TextEditingController untuk dihubungkan langsung ke TextField di UI.
  late TextEditingController searchTextInputController;

  // Variabel untuk menyimpan DisposeWorker dari debounce, agar bisa dibatalkan saat onClose
  Worker? _searchWorker;

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi TextEditingController
    searchTextInputController = TextEditingController();

    // Inisialisasi worker untuk debounce perubahan teks dari TextEditingController
    // Ini akan memicu pembaruan searchQuery setelah 300ms dari ketikan terakhir.
    // Tujuannya adalah mencegah pemfilteran terlalu cepat saat user masih mengetik.
    _searchWorker = debounce(
      // Kita mengobservasi objek TextEditingController itu sendiri.
      // Setiap kali ada perubahan teks di dalamnya, objeknya 'berubah' di mata GetX.
      searchTextInputController.obs,
      (_) {
        // Ambil teks saat ini dari TextEditingController setelah debounce
        final String currentText = searchTextInputController.text;
        // Hanya perbarui searchQuery jika teks benar-benar berbeda
        // Ini menghindari pembaruan yang tidak perlu
        if (searchQuery.value != currentText) {
          searchQuery.value = currentText;
          if (kDebugMode) {
            print(
              'MateriController: searchQuery diperbarui dari TextField (debounce worker): ${searchQuery.value}',
            );
          }
        }
      },
      time: const Duration(milliseconds: 300), // Waktu debounce
    );

    // Dengarkan perubahan pada searchQuery (RxString).
    // Ketika searchQuery berubah (setelah debounce dari TextField),
    // fungsi _applyFilter akan dipanggil untuk memperbarui materiList.
    ever(searchQuery, (String query) {
      if (kDebugMode) {
        print('MateriController: searchQuery RxString changed to: $query');
      }
      _applyFilter(); // Panggil fungsi filter
    });

    // Panggil fungsi untuk mengambil data materi saat controller diinisialisasi
    fetchMateri();
  }

  /// Fungsi untuk mengambil data materi dari API
  Future<void> fetchMateri() async {
    isLoading.value = true; // Set loading menjadi true saat memulai fetch
    errorMessage.value = ''; // Reset pesan error
    if (kDebugMode) {
      print('MateriController: Memulai fetchMateri().');
    }

    try {
      final response = await ApiService.getMateri();
      if (kDebugMode) {
        print(
          'MateriController: Menerima respons dari ApiService.getMateri().',
        );
        // print('MateriController: Respons mentah: $response'); // Hati-hati dengan ini di produksi, bisa terlalu banyak output
      }

      if (response['success'] == true) {
        final dynamic rawMateriData = response['data'];

        if (rawMateriData is List) {
          // Salin data API ke _allMateriList
          _allMateriList.value =
              rawMateriData
                  .map((item) => item as Map<String, dynamic>)
                  .toList();

          if (kDebugMode) {
            print(
              'MateriController: Data materi berhasil dimuat: ${_allMateriList.length} item.',
            );
            // Cetak beberapa item pertama untuk verifikasi data
            for (var i = 0; i < _allMateriList.length && i < 3; i++) {
              print(
                'Materi ${i + 1}: Title: ${_allMateriList[i]['title']}, Description: ${_allMateriList[i]['description']}, YouTube Link: ${_allMateriList[i]['youtube_link']}',
              );
            }
          }
          // Setelah data mentah dimuat, terapkan filter awal
          // Ini penting agar materiList terisi data awal
          _applyFilter();
        } else {
          errorMessage.value =
              'Format data materi tidak valid dari server: Respons "data" bukan List.';
          if (kDebugMode) {
            print(
              'Error: Format data materi tidak valid. Raw data: $rawMateriData',
            );
            print(
              'Error: Runtime Type of problematic rawMateriData: ${rawMateriData.runtimeType}',
            );
          }
        }
      } else {
        errorMessage.value =
            response['message'] as String? ?? 'Gagal memuat materi.';
        if (kDebugMode) {
          print('Error memuat materi: ${errorMessage.value}');
          print('Detail error: ${response['data']}');
        }
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan tidak terduga: $e';
      if (kDebugMode) {
        print('Exception saat fetchMateri: $e');
      }
    } finally {
      isLoading.value = false; // Set loading menjadi false setelah selesai
      if (kDebugMode) {
        print(
          'MateriController: fetchMateri() selesai. isLoading: ${isLoading.value}, errorMessage: ${errorMessage.value}',
        );
      }
    }
  }

  /// Fungsi untuk menerapkan filter pada daftar materi berdasarkan searchQuery.
  /// Ini selalu memfilter dari `_allMateriList` (data asli) untuk memastikan hasil yang benar.
  void _applyFilter() {
    if (kDebugMode) {
      print(
        'MateriController: _applyFilter() dipanggil. Current searchQuery: "${searchQuery.value}"',
      );
    }

    if (searchQuery.value.isEmpty) {
      // Jika searchQuery kosong, tampilkan semua materi dari _allMateriList
      materiList.value = List.from(_allMateriList);
      if (kDebugMode) {
        print(
          'MateriController: searchQuery kosong, menampilkan semua materi: ${materiList.length} item.',
        );
      }
    } else {
      // Jika ada searchQuery, filter materi hanya berdasarkan 'title'
      // Menggunakan .trim() untuk menghilangkan spasi di awal/akhir kueri
      final query = searchQuery.value.trim().toLowerCase();

      materiList.value =
          _allMateriList.where((materi) {
            final title = materi['title']?.toString().toLowerCase() ?? '';

            // FIX: Menggunakan .contains() untuk pencarian yang lebih fleksibel
            // Ini akan mencocokkan jika frasa kueri ada di mana saja dalam judul
            final bool matches = title.contains(query);

            if (kDebugMode) {
              print(
                '  Materi: "${materi['title']}" (lowercase: "$title") | Query (trimmed): "$query" | Matches (contains): $matches',
              );
            }
            return matches;
          }).toList();
    }
    if (kDebugMode) {
      print(
        'MateriController: Filter diterapkan. Jumlah materi yang difilter: ${materiList.length}',
      );
    }
  }

  /// Fungsi untuk refresh data (mengambil ulang dari API dan menerapkan filter).
  Future<void> refreshMateri() async {
    if (kDebugMode) {
      print('MateriController: Memulai refreshMateri().');
    }
    // Opsional: bersihkan teks pencarian saat refresh jika diinginkan
    // searchTextInputController.clear();
    await fetchMateri(); // `WorkspaceMateri` akan memanggil `_applyFilter` setelah data dimuat
  }

  @override
  void onClose() {
    // Pastikan TextEditingController di-dispose untuk mencegah memory leak
    searchTextInputController.dispose();
    // Pastikan debounce worker juga di-dispose
    _searchWorker?.dispose();
    super.onClose();
  }
}
