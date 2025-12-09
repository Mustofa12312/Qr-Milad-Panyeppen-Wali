import 'package:get/get.dart';
import 'present_controller.dart';

class PresentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresentController>(() => PresentController());
  }
}
