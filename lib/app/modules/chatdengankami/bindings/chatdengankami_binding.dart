import 'package:get/get.dart';

import '../controllers/chatdengankami_controller.dart';

class ChatdengankamiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatdengankamiController>(
      () => ChatdengankamiController(),
    );
  }
}
