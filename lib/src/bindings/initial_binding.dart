import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/services/supabase_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Supabase client service (global)
    Get.put<SupabaseService>(
      SupabaseService(Supabase.instance.client),
      permanent: true,
    );
  }
}
