import 'package:get/get.dart';

import '../controllers/detail_serve_controller.dart';

class DetailServeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailServeController>(
      () => DetailServeController(),
    );
  }
}
