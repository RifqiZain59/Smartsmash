import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartsmashapp/app/data/service/api_service.dart';

class LoginController extends GetxController {
  // TextEditingController TIDAK LAGI dideklarasikan di sini.
  // Mereka akan dikelola di LoginView (StatefulWidget).

  // Observable variables untuk UI state
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isPasswordVisible = false.obs;
  final isButtonEnabled =
      false.obs; // Digunakan untuk mengaktifkan/menonaktifkan tombol login

  // Integrasi Google Sign-In dan Firebase Auth
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GetStorage untuk penyimpanan lokal
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Listener untuk TextEditingController akan ditangani di LoginView.
  }

  @override
  void onClose() {
    // TextEditingController TIDAK LAGI perlu dibuang di sini karena sudah tidak ada di controller ini.
    super.onClose(); // Selalu panggil super.onClose() terakhir
  }

  /// Mengubah visibilitas password
  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  /// Memvalidasi input email dan password untuk mengaktifkan tombol login
  /// Menerima email dan password sebagai parameter dari View
  void validateInputs({required String email, required String password}) {
    // Menggunakan GetUtils untuk validasi email yang lebih robust
    final bool isValidEmail = GetUtils.isEmail(email.trim());
    final bool isPasswordNotEmpty = password.trim().isNotEmpty;
    isButtonEnabled.value = isValidEmail && isPasswordNotEmpty;
    // errorMessage tidak perlu di-clear di sini, akan di-clear di awal fungsi login
  }

  /// Menampilkan notifikasi pop-up di tengah layar dengan pesan kustom dan tampilan yang dipercantik
  void showPopUpNotification({
    required String title,
    required String message,
    Color backgroundColor = Colors.red,
    IconData icon = Icons.info_outline,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Pastikan tidak ada dialog lain yang terbuka sebelum menampilkan yang baru
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 24.0,
        ),
        content: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 8),
                blurRadius: 16,
                spreadRadius: 4,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );

    // Otomatis menutup dialog setelah durasi tertentu
    Future.delayed(duration, () {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    });
  }

  /// **Fungsi Login Biasa (Email & Password)**
  /// Menerima email dan password sebagai parameter dari View
  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;
    errorMessage.value = ''; // Hapus pesan error sebelumnya

    // Validasi input di awal
    if (!GetUtils.isEmail(email.trim())) {
      errorMessage.value = 'Email tidak valid.';
      showPopUpNotification(
        title: 'Validasi Input',
        message: errorMessage.value,
        backgroundColor: Colors.orange,
        icon: Icons.warning_amber_rounded,
      );
      isLoading.value = false;
      return;
    }
    if (password.trim().isEmpty) {
      errorMessage.value = 'Password tidak boleh kosong.';
      showPopUpNotification(
        title: 'Validasi Input',
        message: errorMessage.value,
        backgroundColor: Colors.orange,
        icon: Icons.warning_amber_rounded,
      );
      isLoading.value = false;
      return;
    }

    try {
      final result = await ApiService.login(
        email: email.trim(),
        password: password.trim(),
      );

      print("Login result: $result");

      if (result['success'] == true) {
        final token = await ApiService.getToken();
        final Map<String, dynamic>? apiUser = result['data']?['user'];

        if (token != null) {
          await box.write('token', token);
          print("Token disimpan di GetStorage: $token");

          String userName = 'Pengguna'; // Default
          if (apiUser != null) {
            userName = apiUser['nama'] ?? 'Pengguna';
            await box.write('userName', userName);
            await box.write(
              'userEmail',
              apiUser['email'] ?? email.trim(), // Menggunakan parameter email
            );
            await box.write('userId', apiUser['id_user']?.toString() ?? '');
          } else {
            print(
              "Warning: 'user' object not found in login success data. Using email from controller.",
            );
            userName = email.trim().split('@')[0];
            await box.write('userName', userName);
            await box.write(
              'userEmail',
              email.trim(),
            ); // Menggunakan parameter email
          }

          // Navigasi ke halaman berikutnya setelah login sukses
          Get.offAllNamed('/home');

          // Menampilkan notifikasi pop-up setelah navigasi selesai
          Future.delayed(const Duration(milliseconds: 500), () {
            // Pastikan masih di halaman home sebelum menampilkan notifikasi
            if (Get.currentRoute == '/home') {
              showPopUpNotification(
                title: 'Login Berhasil',
                message: 'Selamat datang di Smart Smash, $userName!',
                backgroundColor: Colors.green,
                icon: Icons.check_circle_outline,
              );
            }
          });
        } else {
          final message =
              result['message'] ??
              'Login berhasil, tetapi token tidak ditemukan.';
          errorMessage.value = message;
          showPopUpNotification(
            title: 'Gagal Login',
            message: message,
            icon: Icons.error_outline,
          );
        }
      } else {
        if (result['action_required'] == 'verify_otp') {
          final emailToVerify =
              result['data']?['email'] ??
              email.trim(); // Menggunakan parameter email
          Get.toNamed('/verify-otp', arguments: {'email': emailToVerify});
          showPopUpNotification(
            title: 'Verifikasi Diperlukan',
            message:
                result['message'] ??
                'Akun Anda belum diverifikasi. Silakan verifikasi OTP Anda.',
            backgroundColor: Colors.orange,
            icon: Icons.mark_email_unread_outlined,
          );
        } else {
          final message =
              result['message'] ??
              'Login gagal. Periksa kembali email dan password Anda.';
          errorMessage.value = message;
          showPopUpNotification(
            title: 'Gagal Login',
            message: message,
            icon: Icons.error_outline,
          );
        }
      }
    } catch (e) {
      final msg = 'Terjadi kesalahan: ${e.toString()}';
      errorMessage.value = msg;
      showPopUpNotification(
        title: 'Error Jaringan/Aplikasi',
        message: msg,
        icon: Icons.cloud_off_outlined,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// **Fungsi Login dengan Google**
  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = ''; // Hapus pesan error sebelumnya

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Pengguna membatalkan proses login Google
        isLoading.value = false;
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        errorMessage.value = 'Pengguna Firebase tidak ditemukan.';
        showPopUpNotification(
          title: 'Error',
          message: errorMessage.value,
          icon: Icons.person_off_outlined,
        );
        isLoading.value = false;
        return;
      }

      final idToken = await user.getIdToken();
      if (idToken == null || idToken.isEmpty) {
        errorMessage.value = 'ID Token Firebase tidak tersedia.';
        showPopUpNotification(
          title: 'Error',
          message: errorMessage.value,
          icon: Icons.vpn_key_off_outlined,
        );
        isLoading.value = false;
        return;
      }

      final result = await ApiService.loginWithGoogle(idToken: idToken);
      print("Google login API result: $result");

      if (result['success'] == true) {
        final apiToken = await ApiService.getToken();

        if (apiToken == null) {
          errorMessage.value =
              'Token tidak ditemukan setelah login Google berhasil.';
          showPopUpNotification(
            title: 'Error',
            message: errorMessage.value,
            icon: Icons.error_outline,
          );
          isLoading.value = false;
          return;
        }

        final Map<String, dynamic>? backendUserMap =
            result['data'] is Map<String, dynamic>
                ? result['data'] as Map<String, dynamic>
                : null;

        await box.write('token', apiToken);
        print("Token dari API backend disimpan di GetStorage: $apiToken");

        String userName = 'Pengguna'; // Default
        if (backendUserMap != null) {
          userName = backendUserMap['nama'] ?? user.displayName ?? 'Pengguna';
          await box.write('userName', userName);
          await box.write(
            'userEmail',
            backendUserMap['email'] ?? user.email ?? '',
          );
          await box.write(
            'userId',
            backendUserMap['id_user']?.toString() ?? user.uid,
          );
        } else {
          print(
            "Warning: Backend user map not found in Google login success data. Using Firebase user data as fallback.",
          );
          userName = user.displayName ?? 'Pengguna';
          await box.write('userName', userName);
          await box.write('userEmail', user.email ?? '');
          await box.write('userId', user.uid);
        }

        // Navigasi ke halaman berikutnya setelah login sukses
        Get.offAllNamed('/home');

        // Menampilkan notifikasi pop-up setelah navigasi selesai
        Future.delayed(const Duration(milliseconds: 500), () {
          if (Get.currentRoute == '/home') {
            showPopUpNotification(
              title: 'Login Berhasil',
              message: 'Selamat datang di Smart Smash, $userName!',
              backgroundColor: Colors.green,
              icon: Icons.check_circle_outline,
            );
          }
        });
      } else {
        final failureMessage =
            result['message'] ?? 'Login dengan Google gagal.';
        errorMessage.value = failureMessage;
        showPopUpNotification(
          title: 'Gagal Login Google',
          message: failureMessage,
          icon: Icons.error_outline,
        );
      }
    } catch (e) {
      final msg = 'Login Google gagal: Terjadi kesalahan: ${e.toString()}';
      errorMessage.value = msg;
      showPopUpNotification(
        title: 'Error Aplikasi',
        message: msg,
        icon: Icons.cloud_off_outlined,
      );
      // Pastikan untuk sign out dari Google dan Firebase jika terjadi error
      await _googleSignIn.signOut();
      await _auth.signOut();
    } finally {
      isLoading.value = false;
    }
  }

  // Getter untuk data yang disimpan
  String? getToken() => box.read('token');
  String? getUserName() => box.read('userName');
  String? getUserEmail() => box.read('userEmail');
  String? getUserId() => box.read('userId');
}
