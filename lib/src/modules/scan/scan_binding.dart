import 'package:get/get.dart';

import '../../data/services/supabase_service.dart';
import 'scan_controller.dart';

class ScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanController>(
      () => ScanController(
        supabaseService: Get.find<SupabaseService>(),
        eventName: (Get.arguments?['eventName'] as String?) ?? 'Wisuda Santri',
      ),
    );
  }
}
