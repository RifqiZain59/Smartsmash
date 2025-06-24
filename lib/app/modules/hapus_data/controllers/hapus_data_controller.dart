import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsmashapp/app/data/service/api_service.dart';

class HapusDataController extends GetxController {
  // Observable boolean untuk mengelola status loading
  final isLoading = false.obs;

  // TextEditingController untuk input password di dialog konfirmasi
  final passwordController = TextEditingController();

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }

  // Method untuk menghapus data akun
  Future<void> hapusDataAkun() async {
    // Validasi input password
    if (passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Password harus diisi untuk konfirmasi penghapusan akun.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true; // Set loading menjadi true
    Get.back(); // Tutup dialog konfirmasi

    try {
      final response = await ApiService.deleteAccount(
        password: passwordController.text,
      );

      if (response['success'] == true) {
        Get.snackbar(
          'Berhasil',
          response['message'] ?? 'Akun Anda berhasil dihapus permanen.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Navigasi ke halaman login atau halaman awal setelah penghapusan
        // Sesuaikan rute navigasi Anda
        Get.offAllNamed('/login'); // Contoh navigasi ke halaman login
      } else {
        Get.snackbar(
          'Gagal',
          response['message'] ?? 'Gagal menghapus akun. Silakan coba lagi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false; // Set loading menjadi false
      passwordController.clear(); // Bersihkan password setelah proses
    }
  }
}
