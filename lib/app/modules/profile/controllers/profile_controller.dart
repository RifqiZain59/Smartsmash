import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smartsmashapp/app/data/service/api_service.dart'; // Pastikan path ini benar

class ProfileController extends GetxController {
  // Use clear initial values to prevent null-related issues in the UI
  // These will be displayed until actual data is loaded.
  RxString userName = 'Memuat Nama...'.obs;
  RxString userEmail = 'Memuat Email...'.obs;
  RxString userPhone = ''.obs;

  RxInt selectedIndex =
      2.obs; // Assuming this is for a BottomNavigationBar or similar
  final GetStorage box = GetStorage(); // Initialize GetStorage

  @override
  void onInit() {
    super.onInit();
    loadUserProfile(); // Call this when the controller is initialized
  }

  Future<void> loadUserProfile() async {
    try {
      // 1. Load cached data from GetStorage first for quick display
      userName.value = box.read('userName') ?? 'Nama Pengguna';
      userEmail.value = box.read('userEmail') ?? 'Email Pengguna';
      userPhone.value = box.read('userPhone') ?? '';

      debugPrint('Loaded user profile from GetStorage: ${userName.value}');

      // 2. Fetch the latest data from the API
      final Map<String, dynamic> result = await ApiService.getProfile();

      // 3. Check if the API call was successful and contains valid data
      if (result['success'] == true && result['data'] is Map<String, dynamic>) {
        final Map<String, dynamic> userData = result['data'];

        // 4. Update RxString values only if the API data exists
        // Use null-aware operator (??) to keep existing value if API returns null for a field
        userName.value = userData['nama'] ?? userName.value;
        userEmail.value = userData['email'] ?? userEmail.value;
        userPhone.value = userData['nomor_hp'] ?? userPhone.value;

        // 5. Save the latest data back to GetStorage
        await box.write('userName', userName.value);
        await box.write('userEmail', userEmail.value);
        await box.write('userPhone', userPhone.value);

        debugPrint('Updated user profile from API: ${userName.value}');
      } else {
        // Log if API fetch failed or returned no data
        debugPrint(
          'Failed to load profile from API: ${result['message'] ?? 'No message'}',
        );
        // You can show a snackbar here if needed:
        // Get.snackbar("Info", "Gagal menyinkronkan profil terbaru.");
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
      // Show an error message if necessary
      // Get.snackbar("Error", "Terjadi kesalahan saat memuat profil.");
    }
  }

  Future<void> logout() async {
    try {
      await box.erase(); // Clear all data in GetStorage
      userName.value = '';
      userEmail.value = '';
      userPhone.value = '';
      Get.snackbar("Logout", "Anda telah keluar dari akun.");
      Get.offAllNamed('/login'); // Redirect to the login page
    } catch (e) {
      debugPrint('Logout failed: $e');
    }
  }

  /// Navigates to the terms and conditions page.
  void navigateToTermsAndConditions() {
    Get.toNamed('/syarat-ketentuan');
    debugPrint('Navigating to /syarat-ketentuan');
  }

  /// Navigates to the help center page.
  void navigateToPusatBantuan() {
    Get.toNamed('/pusat-bantuan');
    debugPrint('Navigating to /pusat-bantuan');
  }

  /// Navigates to the chat with us page.
  void navigateToChatdengankami() {
    Get.toNamed('/chatdengankami');
    debugPrint('Navigating to /chatdengankami');
  }

  /// Navigates to the help center page.
  void navigateToHistoryLogin() {
    Get.toNamed('/history-login');
    debugPrint('Navigating to /pusat-bantuan');
  }
}
