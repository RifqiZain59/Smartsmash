import 'package:get/get.dart';

class GrafikController extends GetxController {
  var selectedTab = 0.obs;

  void setTab(int index) {
    selectedTab.value = index;
  }
}
