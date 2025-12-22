import 'package:get/get.dart';
import '../../data/models/guardian.dart';
import '../../data/services/supabase_service.dart';

class AbsentController extends GetxController {
  final SupabaseService supabase = Get.find<SupabaseService>();

  // =====================
  // STATE DATA
  // =====================
  final RxBool isLoading = true.obs;
  final RxList<Guardian> guardians = <Guardian>[].obs;
  final RxList<Guardian> filtered = <Guardian>[].obs;

  // =====================
  // STATE UI (🔥 FIX ERROR)
  // =====================
  final RxString selectedLetter = ''.obs;
  final RxBool showBubble = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAbsent();
  }

  Future<void> loadAbsent() async {
    isLoading.value = true;

    final data = await supabase.getAbsentGuardians();
    guardians.assignAll(data);

    guardians.sort((a, b) => a.idWali.compareTo(b.idWali));
    filtered.assignAll(guardians);

    isLoading.value = false;
  }
}
