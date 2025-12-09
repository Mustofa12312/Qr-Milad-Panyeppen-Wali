import 'package:get/get.dart';
import '../../data/services/supabase_service.dart';

class HomeController extends GetxController {
  final SupabaseService supabase = Get.find();

  // Event name (sudah ada dari versi lama)
  final RxString eventName = 'Wisuda Santri 2025'.obs;

  // Statistik
  final RxInt totalWali = 0.obs;
  final RxInt totalHadir = 0.obs;

  // Getter otomatis
  int get totalBelumHadir => totalWali.value - totalHadir.value;

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  // Mengambil data statistik dari Supabase
  Future<void> fetchStats() async {
    totalWali.value = await supabase.getTotalGuardians();
    totalHadir.value = await supabase.getTotalAttendances();
  }

  // Untuk refresh manual jika diperlukan
  void refreshData() => fetchStats();
}
