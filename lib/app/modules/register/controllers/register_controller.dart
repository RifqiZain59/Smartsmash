import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:smartsmashapp/app/data/service/api_service.dart'; // Sesuaikan path jika perlu
import 'package:get_storage/get_storage.dart'; // Untuk menyimpan token nanti (belum digunakan di register)
import 'package:flutter/foundation.dart'; // Import ini untuk kDebugMode

class RegisterController extends GetxController {
  // --- TextEditingControllers untuk input form ---
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // --- Observable untuk status UI ---
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // --- GetStorage untuk menyimpan data lokal (token, user info) ---
  // Saat ini belum digunakan secara aktif di fungsi register ini,
  // tapi sudah siap jika diperlukan nanti (misal setelah login atau verifikasi OTP final)
  final box = GetStorage();

  // --- Toggle visibilitas password ---
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // --- Toggle visibilitas konfirmasi password ---
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // --- Validasi format email sederhana ---
  bool _isValidEmail(String email) {
    final regex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return regex.hasMatch(email);
  }

  // --- Fungsi utama untuk proses registrasi pengguna ---
  Future<void> registerUser() async {
    final String nama = namaController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text; // Jangan trim password
    final String confirmPassword =
        confirmPasswordController.text; // Jangan trim password

    // --- Validasi input form ---
    if (nama.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnackbar('Error', 'Semua field harus diisi.', Colors.red);
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackbar('Error', 'Format email tidak valid.', Colors.red);
      return;
    }

    if (password.length < 6) {
      _showSnackbar('Error', 'Password minimal 6 karakter.', Colors.red);
      return;
    }

    if (password != confirmPassword) {
      _showSnackbar(
        'Error',
        'Konfirmasi password tidak cocok dengan password.',
        Colors.red,
      );
      return;
    }

    // --- Mengatur status loading dan memanggil API ---
    isLoading.value = true;

    try {
      final Map<String, dynamic> apiResponse = await ApiService.registerUser(
        nama: nama,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (kDebugMode) {
        print('Register API Response: $apiResponse');
      }

      // `ApiService` dirancang untuk selalu mengembalikan Map dengan 'success'.
      // Pengecekan ini sebagai lapisan pertahanan ekstra.
      if (apiResponse['success'] == null) {
        _showSnackbar(
          'Error Kritis',
          'Respons API tidak memiliki status \'success\'. Mohon hubungi developer.',
          Colors.orange.shade800,
        );
        isLoading.value = false;
        return;
      }

      if (apiResponse['success'] == true) {
        // Registrasi berhasil di sisi server
        dynamic responseData = apiResponse['data'];

        if (responseData is Map<String, dynamic>) {
          // Server mungkin mengirim data user langsung di 'data' atau di dalam 'data['user']'
          // Sesuaikan dengan struktur respons backend Anda
          Map<String, dynamic>? userData;
          if (responseData['user'] is Map<String, dynamic>) {
            userData = responseData['user'] as Map<String, dynamic>;
          } else if (responseData.containsKey('id_user') &&
              responseData.containsKey('email')) {
            // Jika data user ada di root 'responseData' (bukan di dalam 'responseData['user']')
            userData = responseData;
          }

          if (userData != null) {
            final String? userId = userData['id_user'] as String?;
            final String? userEmail = userData['email'] as String?;
            // Anda bisa juga mengambil 'nama' jika server mengirimkannya kembali
            // final String? userNameFromResponse = userData['nama'] as String?;

            if (userId != null && userEmail != null) {
              _showSnackbar(
                'Sukses',
                apiResponse['message'] as String? ??
                    'Registrasi berhasil! Silakan verifikasi OTP Anda.',
                Colors.green,
              );

              Get.toNamed(
                '/otp-register', // Pastikan route '/otp' sudah terdaftar
                arguments: {
                  'email': userEmail,
                  'id_user': userId,
                  // 'nama': userNameFromResponse, // Jika perlu
                },
              );

              // Kosongkan field setelah berhasil dan navigasi
              _clearInputFields();
            } else {
              _showSnackbar(
                'Error Data',
                'Data pengguna (ID atau Email) tidak lengkap dari server.',
                Colors.red,
              );
            }
          } else {
            _showSnackbar(
              'Error Data',
              'Struktur data pengguna dalam respons server tidak sesuai.',
              Colors.red,
            );
          }
        } else {
          _showSnackbar(
            'Error Data',
            'Format bagian \'data\' dalam respons server tidak valid setelah registrasi sukses.',
            Colors.orange.shade800,
          );
        }
      } else {
        // Registrasi gagal (apiResponse['success'] == false)
        _showSnackbar(
          'Gagal Registrasi',
          apiResponse['message'] as String? ??
              'Registrasi gagal. Silakan coba lagi.',
          Colors.red,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during registration: $e');
      }
      _showSnackbar(
        'Error Tak Terduga',
        // 'Terjadi kesalahan: ${e.toString()}', // Bisa terlalu teknis untuk user
        'Terjadi masalah koneksi atau kesalahan server. Silakan coba beberapa saat lagi.',
        Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _clearInputFields() {
    namaController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  // Helper untuk menampilkan Snackbar
  void _showSnackbar(String title, String message, Color backgroundColor) {
    if (Get.isSnackbarOpen) {
      // Mencegah snackbar bertumpuk jika error cepat terjadi beruntun
      Get.closeCurrentSnackbar();
    }
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      duration: const Duration(
        seconds: 3,
      ), // Durasi default GetX adalah 3 detik
      isDismissible: true, // Memungkinkan pengguna untuk swipe-to-dismiss
    );
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
