import 'package:get/get.dart';

import '../controllers/juara_controller.dart';

class JuaraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JuaraController>(
      () => JuaraController(),
    );
  }
}
