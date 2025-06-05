import 'package:get/get.dart';

class PilihanController extends GetxController {
  var currentPage = 0.obs;

  void goToRegister() {
    Get.toNamed(
      '/register',
    ); // atau Get.offNamed('/register') jika tidak ingin kembali
  }

  void goToLogin() {
    Get.toNamed('/login');
  }
}
