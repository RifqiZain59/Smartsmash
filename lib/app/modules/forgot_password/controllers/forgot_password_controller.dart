import 'package:get/get.dart';
import 'package:smartsmashapp/app/data/service/api_service.dart';
import 'dart:async'; // Import for Timer

class ForgotPasswordController extends GetxController {
  final RxBool showOtpAndNewPasswordFields = false.obs;
  final RxBool isOtpVerified = false.obs;
  final RxString _resetToken = ''.obs;
  final RxBool isLoading = false.obs; // Variabel baru untuk status loading
  final RxBool isPasswordVisible =
      false.obs; // Variabel baru untuk visibilitas password

  // RxInt to track the cooldown for resending OTP
  final RxInt resendOtpCooldown = 0.obs;
  Timer? _resendOtpTimer; // Timer instance

  // --- NEW: Function to start the resend OTP cooldown timer ---
  void _startResendOtpTimer() {
    const int cooldownDuration = 60; // 60 seconds cooldown
    resendOtpCooldown.value = cooldownDuration;
    _resendOtpTimer?.cancel(); // Cancel any existing timer
    _resendOtpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendOtpCooldown.value > 0) {
        resendOtpCooldown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  // Fungsi untuk mengirim OTP ke email
  void sendOtp({required String email}) async {
    isLoading.value = true; // Set loading ke true
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Masukkan alamat email yang valid.',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false; // Set loading ke false jika ada error
      return;
    }

    // Panggil API untuk mengirim OTP
    final response = await ApiService.requestPasswordResetOtp(email: email);

    if (response['success']) {
      Get.snackbar(
        'Sukses',
        response['message'] ?? 'Kode OTP telah dikirim ke email Anda.',
        snackPosition: SnackPosition.BOTTOM,
      );
      showOtpAndNewPasswordFields.value = true;
      _startResendOtpTimer(); // Start cooldown after sending OTP
    } else {
      Get.snackbar(
        'Error',
        response['message'] ?? 'Gagal mengirim OTP. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    print('Permintaan OTP dikirim untuk: $email');
    isLoading.value = false; // Set loading ke false setelah selesai
  }

  // --- NEW: Function to resend OTP ---
  void resendOtp({required String email}) async {
    if (resendOtpCooldown.value > 0) {
      Get.snackbar(
        'Peringatan',
        'Mohon tunggu ${resendOtpCooldown.value} detik sebelum meminta ulang OTP.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    // Reuse the sendOtp logic
    sendOtp(email: email); // sendOtp sudah mengelola isLoading
  }

  // Fungsi untuk memverifikasi OTP
  Future<void> verifyOtp({required String email, required String otp}) async {
    isLoading.value = true; // Set loading ke true
    if (email.isEmpty || otp.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan kode OTP harus diisi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false; // Set loading ke false jika ada error
      return;
    }

    final response = await ApiService.verifyPasswordResetOtp(
      email: email,
      otp: otp,
    );

    if (response['success']) {
      Get.snackbar(
        'Sukses',
        response['message'] ?? 'OTP berhasil diverifikasi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      if (response['data'] != null &&
          response['data'].containsKey('reset_token')) {
        _resetToken.value = response['data']['reset_token'];
        isOtpVerified.value = true;
      } else {
        Get.snackbar(
          'Error',
          'Token reset tidak ditemukan dalam respons API.',
          snackPosition: SnackPosition.BOTTOM,
        );
        isOtpVerified.value = false;
      }
    } else {
      Get.snackbar(
        'Error',
        response['message'] ?? 'Verifikasi OTP gagal. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      isOtpVerified.value = false;
    }
    isLoading.value = false; // Set loading ke false setelah selesai
  }

  // Fungsi untuk mereset kata sandi menggunakan reset_token
  void resetPassword({
    required String email,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    isLoading.value = true; // Set loading ke true
    if (email.isEmpty ||
        newPassword.isEmpty ||
        confirmNewPassword.isEmpty ||
        _resetToken.isEmpty ||
        !isOtpVerified.value) {
      Get.snackbar(
        'Error',
        'Semua bidang harus diisi dan OTP harus diverifikasi terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false; // Set loading ke false jika ada error
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar(
        'Error',
        'Kata sandi baru harus minimal 6 karakter.',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false; // Set loading ke false jika ada error
      return;
    }

    if (newPassword != confirmNewPassword) {
      Get.snackbar(
        'Error',
        'Konfirmasi kata sandi tidak cocok.',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false; // Set loading ke false jika ada error
      return;
    }

    final response = await ApiService.resetPassword(
      email: email,
      resetToken: _resetToken.value,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );

    if (response['success']) {
      Get.snackbar(
        'Sukses',
        response['message'] ?? 'Kata sandi Anda berhasil direset!',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Kata sandi direset untuk: $email');
      Get.offAllNamed('/login');
    } else {
      Get.snackbar(
        'Error',
        response['message'] ?? 'Gagal mereset kata sandi. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    isLoading.value = false; // Set loading ke false setelah selesai
  }

  // Fungsi untuk mengubah visibilitas kata sandi
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {
    _resendOtpTimer?.cancel(); // Cancel timer when controller is closed
    super.onClose();
  }
}
