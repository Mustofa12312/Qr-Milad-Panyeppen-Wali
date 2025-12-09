import 'package:get/get.dart';

// ============ MAIN (BOTTOM NAVIGATION BAR) ============
import '../modules/main/main_binding.dart';
import '../modules/main/main_view.dart';

// ============ LOGIN ============
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';

// ============ HOME ============
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';

// ============ SCAN ============
import '../modules/scan/scan_binding.dart';
import '../modules/scan/scan_view.dart';

// ============ PRESENT ============
import '../modules/present/present_binding.dart';
import '../modules/present/present_view.dart';

// ============ ABSENT ============
import '../modules/absent/absent_binding.dart';
import '../modules/absent/absent_view.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    // LOGIN
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),

    // MAIN ROOT (BOTTOM NAVIGATION)
    GetPage(
      name: AppRoutes.home,
      page: () => const MainView(),
      binding: MainBinding(),
    ),

    // SCAN
    GetPage(
      name: AppRoutes.scan,
      page: () => const ScanView(),
      binding: ScanBinding(),
    ),

    // PRESENT
    GetPage(
      name: AppRoutes.present,
      page: () => const PresentView(),
      binding: PresentBinding(),
    ),

    // ABSENT
    GetPage(
      name: AppRoutes.absent,
      page: () => const AbsentView(),
      binding: AbsentBinding(),
    ),

    // OPSIONAL: akses HomeView langsung
    GetPage(
      name: '/homeview',
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
