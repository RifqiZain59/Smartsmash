import 'package:get/get.dart';
import 'package:smartsmashapp/app/data/service/api_service.dart';

class HistoryLoginController extends GetxController {
  final isLoading = false.obs;
  final loginHistory = <Map<String, dynamic>>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLoginHistory(); // Panggil saat controller diinisialisasi
  }

  Future<void> fetchLoginHistory() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await ApiService.getProfile();
      if (response['success'] == true) {
        final userData = response['data'] as Map<String, dynamic>;
        if (userData.containsKey('login_history') &&
            userData['login_history'] is List) {
          loginHistory.assignAll(
            List<Map<String, dynamic>>.from(userData['login_history']),
          );
        } else {
          errorMessage.value =
              'Data riwayat login tidak ditemukan atau formatnya tidak valid.';
        }
      } else {
        errorMessage.value =
            response['message'] as String? ?? 'Gagal mengambil riwayat login.';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Metode lain di controller Anda
  void increment() {
    // Contoh metode lain yang tidak terkait langsung dengan API
  }
}
