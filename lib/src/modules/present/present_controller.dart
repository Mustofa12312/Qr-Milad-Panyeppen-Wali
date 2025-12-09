import 'package:get/get.dart';
import '../../data/models/guardian.dart';
import '../../data/services/supabase_service.dart';

class PresentController extends GetxController {
  final SupabaseService supabase = Get.find();

  final RxBool isLoading = true.obs;
  final RxList<Guardian> guardians = <Guardian>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPresent();
  }

  Future<void> loadPresent() async {
    try {
      isLoading.value = true;
      guardians.value = await supabase.getPresentGuardians();
    } finally {
      isLoading.value = false;
    }
  }
}
