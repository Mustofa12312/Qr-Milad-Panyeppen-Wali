import 'package:get/get.dart';
import 'main_controller.dart';

// Tambahkan:
import '../home/home_binding.dart';
import '../present/present_binding.dart';
import '../absent/absent_binding.dart';
import '../scan/scan_binding.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Controller untuk BottomNavigation
    Get.lazyPut<MainController>(() => MainController());

    // Controller halaman-halaman di dalam BottomNav
    HomeBinding().dependencies();
    PresentBinding().dependencies();
    AbsentBinding().dependencies();
    ScanBinding().dependencies();
  }
}
