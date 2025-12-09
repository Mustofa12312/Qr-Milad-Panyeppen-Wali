import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  final emailC = ''.obs;
  final passC = ''.obs;
  final isLoading = false.obs;

  Future<void> login() async {
    if (emailC.value.isEmpty || passC.value.isEmpty) {
      Get.snackbar("Login gagal", "Email & password wajib diisi");
      return;
    }

    try {
      isLoading.value = true;

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailC.value.trim(),
        password: passC.value.trim(),
      );

      if (response.session != null) {
        // LOGIN BERHASIL → MASUK HOME
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar("Login gagal", "Email atau password salah.");
      }
    } catch (e) {
      Get.snackbar("Login gagal", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    // LOGOUT BENAR → kembali ke login
    await Supabase.instance.client.auth.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
