import 'package:get/get.dart';
import 'package:qr_wali_santri/src/modules/absent/absent_controller.dart';

class AbsentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbsentController>(() => AbsentController());
  }
}
