import 'package:get/get.dart';

import '../controllers/detail_backhand_controller.dart';

class DetailBackhandBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailBackhandController>(
      () => DetailBackhandController(),
    );
  }
}
