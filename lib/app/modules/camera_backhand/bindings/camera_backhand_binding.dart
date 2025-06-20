import 'package:get/get.dart';

import '../controllers/camera_backhand_controller.dart';

class CameraBackhandBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraBackhandController>(
      () => CameraBackhandController(),
    );
  }
}
