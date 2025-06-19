import 'package:flutter/foundation.dart'; // Untuk kDebugMode
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Diperlukan untuk Colors, Get.snackbar, dll.
import 'package:smartsmashapp/app/data/service/api_service.dart'; // Import ApiService

// Ganti nama kelas dari OtpController menjadi OtpRegisterasiController
// agar sesuai dengan nama file dan tidak terjadi duplikasi nama
class OtpRegisterController extends GetxController {
  // Properti Observable untuk digunakan di UI
  var userEmail = ''.obs; // Email yang akan ditampilkan di UI
  var otpCode = ''.obs; // Kode OTP yang diinput pengguna
  var isLoading = false.obs; // Indikator loading untuk mencegah double submit
  var isLoadingOverlay =
      false.obs; // New: Indikator loading untuk overlay full-screen
  var errorMessage = ''.obs; // Untuk menampilkan pesan error di UI

  // TextEditingController untuk input OTP
  final otpTextController = TextEditingController();

  // Simpan ID pengguna jika diperlukan untuk logika lain, meskipun tidak digunakan di verify/resend saat ini
  String? _receivedUserId;

  // Konstruktor default, argumen akan diproses di onInit
  OtpRegisterController(); // Sesuaikan nama konstruktor

  @override
  void onInit() {
    super.onInit();
    _processArguments(); // Panggil pemroses argumen di sini
    // Inisialisasi lain yang mungkin Anda perlukan
  }

  void _processArguments() {
    final arguments = Get.arguments; // Get.arguments bersifat dynamic

    if (arguments is Map<String, dynamic>) {
      final String? emailFromArgs = arguments['email'] as String?;
      _receivedUserId = arguments['id_user'] as String?; // Simpan jika perlu

      if (emailFromArgs != null) {
        userEmail.value = emailFromArgs;
        if (kDebugMode) {
          print('Email untuk OTP (from onInit): ${userEmail.value}');
          print('User ID untuk OTP (from onInit): $_receivedUserId');
        }
      } else {
        _handleMissingEmailArgument();
      }

      if (_receivedUserId == null) {
        _showSnackbar(
          'Peringatan Navigasi',
          'ID Pengguna tidak ditemukan dalam argumen.',
          Colors.orange,
          duration: const Duration(seconds: 4),
        );
      }
    } else {
      _handleInvalidOrMissingArguments();
    }
  }

  void _handleMissingEmailArgument() {
    userEmail.value =
        'email_tidak_diterima'; // Email fallback yang jelas invalid
    _showSnackbar(
      'Error Navigasi Kritis',
      'Email tidak valid untuk verifikasi OTP. Harap ulangi proses registrasi.',
      Colors.red.shade700,
      duration: const Duration(seconds: 5),
    );
  }

  void _handleInvalidOrMissingArguments() {
    userEmail.value = 'argumen_tidak_valid'; // Email fallback
    _showSnackbar(
      'Error Navigasi Kritis',
      'Data navigasi ke halaman OTP tidak lengkap. Harap ulangi proses registrasi.',
      Colors.red.shade700,
      duration: const Duration(seconds: 5),
    );
  }

  // Metode untuk mengatur nilai OTP dari input field
  void setOtp(String value) {
    otpCode.value = value;
    if (value.isNotEmpty) {
      errorMessage.value = ''; // Hapus pesan error saat pengguna mulai mengetik
    }
  }

  // Fungsi untuk memverifikasi OTP
  Future<void> verifyOtp() async {
    // Mencegah panggilan API ganda jika sedang dalam proses loading
    if (isLoading.value) {
      if (kDebugMode) {
        print('Sudah dalam proses loading, mencegah panggilan API duplikat.');
      }
      return;
    }

    if (userEmail.value.isEmpty ||
        userEmail.value.contains('_tidak_') ||
        userEmail.value.contains('_invalid_')) {
      errorMessage.value = 'Email tidak valid untuk verifikasi.';
      _showSnackbar('Error Validasi', errorMessage.value, Colors.red);
      return;
    }
    if (otpCode.value.isEmpty) {
      errorMessage.value = 'Kode OTP tidak boleh kosong.';
      _showSnackbar('Error Validasi', errorMessage.value, Colors.red);
      return;
    }

    isLoading.value = true;
    isLoadingOverlay.value = true; // Set overlay to true
    errorMessage.value = ''; // Reset error message

    try {
      final Map<String, dynamic> res = await ApiService.verifyOtp(
        email: userEmail.value,
        otp: otpCode.value,
      );

      // Menambahkan pengecekan untuk res['success'] == null
      if (res['success'] == null) {
        errorMessage.value =
            'Respons server tidak dikenali (missing success status).';
        _showSnackbar('Error Server', errorMessage.value, Colors.deepOrange);
        isLoading.value = false;
        isLoadingOverlay.value = false; // Set overlay to false on error
        return;
      }

      if (res['success'] == true) {
        final dynamic responseData = res['data'];
        // Memastikan token ada dan bertipe String sebelum disimpan
        // Berdasarkan log, endpoint verify-otp ini tidak mengembalikan token,
        // sehingga peringatan di debug mode adalah normal.
        if (responseData is Map<String, dynamic> &&
            responseData['token'] is String) {
          await ApiService.saveToken(responseData['token'] as String);
          if (kDebugMode) {
            print('Token berhasil disimpan setelah verifikasi OTP.');
          }
        } else if (kDebugMode) {
          print(
            'Peringatan: Token tidak ditemukan atau bukan String dalam data respons verifikasi OTP.',
          );
        }

        _showSnackbar(
          'Sukses',
          (res['message'] as String?) ?? 'Verifikasi OTP berhasil!',
          Colors.green,
        );
        Get.offAllNamed(
          '/login',
        ); // Rute telah diubah ke '/login' sesuai permintaan
      } else {
        errorMessage.value =
            (res['message'] as String?) ?? 'Verifikasi OTP gagal.';
        _showSnackbar('Gagal Verifikasi', errorMessage.value, Colors.red);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error verifying OTP: $e');
      }
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      _showSnackbar(
        'Error Tak Terduga',
        'Gagal memverifikasi OTP. Coba lagi nanti.',
        Colors.red,
      );
    } finally {
      isLoading.value = false;
      isLoadingOverlay.value = false; // Always set overlay to false in finally
    }
  }

  // Fungsi untuk mengirim ulang OTP
  Future<void> resendOtp() async {
    // Mencegah panggilan API ganda jika sedang dalam proses loading
    if (isLoading.value) {
      if (kDebugMode) {
        print('Sudah dalam proses loading, mencegah panggilan API duplikat.');
      }
      return;
    }

    if (userEmail.value.isEmpty ||
        userEmail.value.contains('_tidak_') ||
        userEmail.value.contains('_invalid_')) {
      errorMessage.value = 'Email tidak valid untuk mengirim ulang OTP.';
      _showSnackbar('Error Validasi', errorMessage.value, Colors.red);
      return;
    }

    isLoading.value = true;
    isLoadingOverlay.value = true; // Set overlay to true
    errorMessage.value = ''; // Reset error message

    try {
      final Map<String, dynamic> res = await ApiService.resendOtp(
        email: userEmail.value,
      );

      // Menambahkan pengecekan untuk res['success'] == null
      if (res['success'] == null) {
        errorMessage.value =
            'Respons server tidak dikenali (missing success status).';
        _showSnackbar('Error Server', errorMessage.value, Colors.deepOrange);
        isLoading.value = false;
        isLoadingOverlay.value = false; // Set overlay to false on error
        return;
      }

      if (res['success'] == true) {
        _showSnackbar(
          'Sukses',
          (res['message'] as String?) ?? 'Kode OTP baru telah dikirim!',
          Colors.green,
        );
      } else {
        errorMessage.value =
            (res['message'] as String?) ?? 'Gagal mengirim ulang OTP.';
        _showSnackbar('Gagal Mengirim Ulang', errorMessage.value, Colors.red);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error resending OTP: $e');
      }
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      _showSnackbar(
        'Error Tak Terduga',
        'Gagal mengirim ulang OTP. Coba lagi nanti.',
        Colors.red,
      );
    } finally {
      isLoading.value = false;
      isLoadingOverlay.value = false; // Always set overlay to false in finally
    }
  }

  void _showSnackbar(
    String title,
    String message,
    Color backgroundColor, {
    Duration? duration,
  }) {
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
      duration: duration ?? const Duration(seconds: 3),
      isDismissible: true,
    );
  }

  @override
  void onClose() {
    otpTextController.dispose();
    super.onClose();
  }
}
