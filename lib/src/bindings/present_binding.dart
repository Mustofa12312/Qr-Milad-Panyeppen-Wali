import 'package:get/get.dart';

import 'package:qr_wali_santri/src/modules/present/present_controller.dart';

class PresentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresentController>(() => PresentController());
  }
}
