import 'package:get/get.dart';

import '../controllers/hapus_data_controller.dart';

class HapusDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HapusDataController>(
      () => HapusDataController(),
    );
  }
}
