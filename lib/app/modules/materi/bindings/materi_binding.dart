// smartsmashapp/app/modules/materi/bindings/materi_binding.dart
import 'package:get/get.dart';
import 'package:smartsmashapp/app/modules/materi/controllers/materi_controller.dart'; // <<<--- Ensure this path is correct

class MateriBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MateriController>(() => MateriController());
  }
}
