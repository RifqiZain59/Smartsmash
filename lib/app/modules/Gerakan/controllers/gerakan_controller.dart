import 'package:get/get.dart';

class GerakanController extends GetxController {
  //TODO: Implement GerakanController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  // Methods to navigate to specific detail pages
  void goToDetailForehand() {
    Get.toNamed('/detail-forehand');
  }

  void goToDetailBackhand() {
    Get.toNamed('/detail-backhand');
  }

  void goToDetailServe() {
    Get.toNamed('/detail-serve');
  }

  void goToDetailSmash() {
    Get.toNamed('/detail-smash');
  }
}
