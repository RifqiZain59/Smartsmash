import 'package:get/get.dart';

import '../controllers/detail_forehand_controller.dart';

class DetailForehandBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailForehandController>(
      () => DetailForehandController(),
    );
  }
}
