import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:smartsmashapp/app/data/service/api_service.dart'; // Sesuaikan path jika perlu
import 'package:get_storage/get_storage.dart'; // Untuk menyimpan token nanti (belum digunakan di register)
import 'package:flutter/foundation.dart'; // Import ini untuk kDebugMode

class RegisterController extends GetxController {
  // --- TextEditingControllers for form inputs ---
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // --- Observables for UI status ---
  var isLoading = false.obs; // Untuk indikator loading di dalam tombol
  var isLoadingOverlay = false.obs; // Untuk full screen loading overlay
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // --- Observables for password validation criteria ---
  var hasUppercase = false.obs;
  var hasLowercase = false.obs;
  var hasDigit = false.obs;
  var hasMinLength = false.obs; // Minimum 8 characters
  var isPasswordValidOverall = false.obs; // Overall password validity status
  var isEmailValid = false.obs; // Status validasi format email
  var isNamaValid = false.obs; // Status validasi nama
  var isConfirmPasswordMatch = false.obs; // Status konfirmasi password

  // --- Overall form validity ---
  var isFormValid = false.obs; // Untuk mengaktifkan/menonaktifkan tombol utama

  // --- GetStorage to store local data (token, user info) ---
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in all relevant fields to update form validity
    namaController.addListener(_updateFormValidity);
    emailController.addListener(_updateFormValidity);
    passwordController.addListener(
      _validatePassword,
    ); // Panggil _validatePassword dulu
    passwordController.addListener(
      _updateFormValidity,
    ); // Lalu update validitas form
    confirmPasswordController.addListener(_updateFormValidity);
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.removeListener(_updateFormValidity); // Hapus listener
    emailController.dispose();
    passwordController.removeListener(_validatePassword);
    passwordController.removeListener(_updateFormValidity); // Hapus listener
    passwordController.dispose();
    confirmPasswordController.removeListener(
      _updateFormValidity,
    ); // Hapus listener
    confirmPasswordController.dispose();
    super.onClose();
  }

  // --- Toggle password visibility ---
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // --- Toggle confirm password visibility ---
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // --- Simple email format validation ---
  bool _checkEmailFormat(String email) {
    final regex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return regex.hasMatch(email);
  }

  // --- Password validation logic ---
  void _validatePassword() {
    final password = passwordController.text;

    hasUppercase.value = password.contains(RegExp(r'[A-Z]'));
    hasLowercase.value = password.contains(RegExp(r'[a-z]'));
    hasDigit.value = password.contains(RegExp(r'[0-9]'));
    hasMinLength.value = password.length >= 8;

    isPasswordValidOverall.value =
        hasUppercase.value &&
        hasLowercase.value &&
        hasDigit.value &&
        hasMinLength.value;

    // Juga panggil updateFormValidity di sini karena perubahan password memengaruhi validitas form
    _updateFormValidity();
  }

  // --- Overall form validity check ---
  void _updateFormValidity() {
    isEmailValid.value = _checkEmailFormat(emailController.text.trim());
    isNamaValid.value = namaController.text.trim().isNotEmpty;
    isConfirmPasswordMatch.value =
        passwordController.text == confirmPasswordController.text &&
        confirmPasswordController.text.isNotEmpty; // Juga pastikan tidak kosong

    isFormValid.value =
        isNamaValid.value &&
        isEmailValid.value &&
        isPasswordValidOverall.value &&
        isConfirmPasswordMatch.value;
  }

  // --- Main function for user registration process ---
  Future<void> registerUser() async {
    final String nama = namaController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text; // Do not trim password
    final String confirmPassword =
        confirmPasswordController.text; // Do not trim password

    // Re-check form validity one last time before API call
    _updateFormValidity();
    if (!isFormValid.value) {
      _showSnackbar(
        'Error',
        'Mohon lengkapi semua field dan pastikan valid.',
        Colors.red,
      );
      return;
    }

    isLoading.value = true; // For button loading
    isLoadingOverlay.value = true; // For full screen overlay

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

      if (apiResponse['success'] == null) {
        _showSnackbar(
          'Error Kritis',
          'Respons API tidak memiliki status \'success\'. Mohon hubungi developer.',
          Colors.orange.shade800,
        );
        return;
      }

      if (apiResponse['success'] == true) {
        dynamic responseData = apiResponse['data'];

        if (responseData is Map<String, dynamic>) {
          Map<String, dynamic>? userData;
          if (responseData['user'] is Map<String, dynamic>) {
            userData = responseData['user'] as Map<String, dynamic>;
          } else if (responseData.containsKey('id_user') &&
              responseData.containsKey('email')) {
            userData = responseData;
          }

          if (userData != null) {
            final String? userId = userData['id_user'] as String?;
            final String? userEmail = userData['email'] as String?;

            if (userId != null && userEmail != null) {
              _showSnackbar(
                'Sukses',
                apiResponse['message'] as String? ??
                    'Registrasi berhasil! Silakan verifikasi OTP Anda.',
                Colors.green,
              );

              Get.toNamed(
                '/otp-register',
                arguments: {'email': userEmail, 'id_user': userId},
              );

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
        // Registration failed (apiResponse['success'] == false)
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
        'Terjadi masalah koneksi atau kesalahan server. Silakan coba beberapa saat lagi.',
        Colors.red,
      );
    } finally {
      isLoading.value = false;
      isLoadingOverlay.value =
          false; // Turn off overlay regardless of success/failure
    }
  }

  void _clearInputFields() {
    namaController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    // Reset validation states after clearing
    hasUppercase.value = false;
    hasLowercase.value = false;
    hasDigit.value = false;
    hasMinLength.value = false;
    isPasswordValidOverall.value = false;
    isEmailValid.value = false;
    isNamaValid.value = false;
    isConfirmPasswordMatch.value = false;
    isFormValid.value = false;
  }

  // Helper to show Snackbar
  void _showSnackbar(String title, String message, Color backgroundColor) {
    if (Get.isSnackbarOpen) {
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
      duration: const Duration(seconds: 3),
      isDismissible: true,
    );
  }
}
