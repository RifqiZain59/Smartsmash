import 'package:get/get.dart';

import '../controllers/acara_controller.dart';

class AcaraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AcaraController>(
      () => AcaraController(),
    );
  }
}
