import 'package:get/get.dart';

import '../controllers/pilihan_controller.dart';

class PilihanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PilihanController>(
      () => PilihanController(),
    );
  }
}
