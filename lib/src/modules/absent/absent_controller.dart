import 'package:get/get.dart';
import '../../data/models/guardian.dart';
import '../../data/services/supabase_service.dart';

class AbsentController extends GetxController {
  final SupabaseService supabase = Get.find();

  final RxBool isLoading = true.obs;

  final RxList<Guardian> guardians = <Guardian>[].obs;

  // SEARCH
  final searchC = ''.obs;
  final RxList<Guardian> filtered = <Guardian>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAbsent();
    ever(searchC, (_) => applyFilter());
  }

  Future<void> loadAbsent() async {
    isLoading.value = true;

    guardians.value = await supabase.getAbsentGuardians();

    // urutkan id
    guardians.sort((a, b) => a.idWali.compareTo(b.idWali));

    filtered.assignAll(guardians);

    isLoading.value = false;
  }

  void applyFilter() {
    final q = searchC.value.toLowerCase();

    if (q.isEmpty) {
      filtered.assignAll(guardians);
      return;
    }

    filtered.assignAll(
      guardians.where(
        (g) =>
            g.namaWali.toLowerCase().contains(q) ||
            g.namaMurid.toLowerCase().contains(q),
      ),
    );
  }
}
