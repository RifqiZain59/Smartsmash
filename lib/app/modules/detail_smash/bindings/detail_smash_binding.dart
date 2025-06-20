import 'package:get/get.dart';

import '../controllers/detail_smash_controller.dart';

class DetailSmashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailSmashController>(
      () => DetailSmashController(),
    );
  }
}
