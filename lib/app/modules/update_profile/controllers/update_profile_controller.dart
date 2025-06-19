import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsmashapp/app/data/service/api_service.dart';
import 'package:smartsmashapp/app/routes/app_pages.dart'; // Pastikan Anda memiliki rute ini atau sesuaikan

class UpdateProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Observable untuk menunjukkan status loading pada tombol atau bagian kecil
  var isLoading = false.obs;

  // BARU: Observable untuk menunjukkan status loading overlay penuh layar
  var isLoadingOverlay =
      false.obs; // NEW: Indikator loading untuk overlay full-screen

  @override
  void onInit() {
    super.onInit();
    // Panggil fungsi untuk memuat data profil saat controller diinisialisasi
    _loadProfileData();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Menampilkan notifikasi pop-up di tengah layar dengan pesan kustom dan tampilan yang dipercantik
  void showPopUpNotification({
    required String title,
    required String message,
    Color backgroundColor = Colors.red,
    IconData icon = Icons.info_outline, // Icon default untuk informasi
    Duration duration = const Duration(seconds: 3), // Durasi default pop-up
  }) {
    // Tutup dialog yang mungkin sudah terbuka sebelum menampilkan yang baru
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    Get.dialog(
      AlertDialog(
        backgroundColor:
            Colors.transparent, // Membuat latar belakang transparan
        contentPadding: EdgeInsets.zero, // Menghilangkan padding default
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 24.0,
        ), // Padding dari tepi layar
        content: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12), // Sudut membulat
            boxShadow: [
              // Menambahkan bayangan untuk efek kedalaman
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 8),
                blurRadius: 16,
                spreadRadius: 4,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ), // Padding internal
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 48,
              ), // Icon yang lebih besar
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
      barrierDismissible: true, // Pop-up bisa ditutup dengan tap di luar area
    );

    // Otomatis tutup pop-up setelah durasi tertentu
    Future.delayed(duration, () {
      if (Get.isDialogOpen == true) {
        // Pastikan dialog masih terbuka sebelum menutupnya
        Get.back();
      }
    });
  }

  // Metode untuk memuat data profil dari API
  Future<void> _loadProfileData() async {
    isLoading.value = true;
    isLoadingOverlay.value = true; // Aktifkan overlay saat mulai memuat data
    try {
      final response = await ApiService.getProfile();
      if (response['success']) {
        final userData = response['data'];
        nameController.text = userData['nama'] ?? '';
        emailController.text = userData['email'] ?? '';
      } else {
        showPopUpNotification(
          title: 'Error',
          message: response['message'] ?? 'Gagal memuat data profil.',
          backgroundColor: Colors.redAccent,
          icon: Icons.error_outline,
        );
      }
    } catch (e) {
      showPopUpNotification(
        title: 'Error',
        message: 'Terjadi kesalahan saat memuat data profil: $e',
        backgroundColor: Colors.redAccent,
        icon: Icons.cloud_off_outlined,
      );
    } finally {
      isLoading.value = false;
      isLoadingOverlay.value =
          false; // Nonaktifkan overlay setelah selesai (berhasil/gagal)
    }
  }

  // Metode untuk memperbarui profil
  Future<void> updateProfile() async {
    isLoading.value = true;
    isLoadingOverlay.value =
        true; // Aktifkan overlay saat mulai memperbarui profil

    final String name = nameController.text;
    final String oldPassword = oldPasswordController.text;
    final String newPassword = newPasswordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // Validasi: Jika newPassword diisi, tapi tidak cocok dengan confirmPassword
    if (newPassword.isNotEmpty && newPassword != confirmPassword) {
      showPopUpNotification(
        title: 'Error',
        message: 'Kata sandi baru dan konfirmasi kata sandi tidak cocok.',
        backgroundColor: Colors.redAccent,
        icon: Icons.error_outline,
      );
      isLoading.value = false;
      isLoadingOverlay.value =
          false; // Pastikan overlay dinonaktifkan jika ada validasi gagal
      return;
    }

    // Validasi: Jika newPassword diisi, tapi oldPassword kosong
    if (newPassword.isNotEmpty && oldPassword.isEmpty) {
      showPopUpNotification(
        title: 'Peringatan',
        message:
            'Untuk mengubah kata sandi, Anda harus memasukkan kata sandi lama.',
        backgroundColor: Colors.orangeAccent,
        icon: Icons.warning_amber_rounded,
      );
      isLoading.value = false;
      isLoadingOverlay.value =
          false; // Pastikan overlay dinonaktifkan jika ada validasi gagal
      return;
    }

    try {
      final response = await ApiService.updateProfile(
        nama: name,
        currentPassword: oldPassword.isEmpty ? null : oldPassword,
        newPassword: newPassword.isEmpty ? null : newPassword,
        confirmNewPassword: confirmPassword.isEmpty ? null : confirmPassword,
      );

      if (response['success']) {
        // Ambil nama pengguna yang berhasil diupdate
        final String updatedUserName =
            nameController.text.isNotEmpty
                ? nameController.text
                : 'Pengguna'; // Gunakan nama dari controller jika tidak kosong

        // Bersihkan field password setelah update berhasil
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        // Navigasi ke halaman home terlebih dahulu
        Get.offAllNamed(Routes.HOME);

        // Tunda sedikit untuk memastikan halaman home termuat, lalu tampilkan pop-up
        Future.delayed(const Duration(milliseconds: 200), () {
          if (Get.currentRoute == Routes.HOME) {
            // Pastikan sudah di halaman home
            showPopUpNotification(
              title: 'Berhasil Update',
              message: 'Profil Anda berhasil diperbarui, $updatedUserName!',
              backgroundColor: Colors.green,
              icon: Icons.check_circle_outline,
            );
          }
        });
      } else {
        showPopUpNotification(
          title: 'Error',
          message: response['message'] ?? 'Gagal memperbarui profil.',
          backgroundColor: Colors.redAccent,
          icon: Icons.error_outline,
        );
      }
    } catch (e) {
      showPopUpNotification(
        title: 'Error',
        message: 'Terjadi kesalahan saat memperbarui profil: $e',
        backgroundColor: Colors.redAccent,
        icon: Icons.cloud_off_outlined,
      );
    } finally {
      isLoading.value = false;
      isLoadingOverlay.value =
          false; // Nonaktifkan overlay setelah selesai (berhasil/gagal)
    }
  }
}
