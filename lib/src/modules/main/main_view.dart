import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_view.dart';
import '../present/present_view.dart';
import '../absent/absent_view.dart';
import '../scan/scan_view.dart';
import 'main_controller.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  Widget _loadPage(int index) {
    switch (index) {
      case 0:
        return const HomeView();
      case 1:
        return const ScanView();
      // return const PresentView();
      case 2:
        return const PresentView();
      case 3:
        return const AbsentView();
      // return const ScanView();
      default:
        return const HomeView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      // ==========================================
      // SUPER SMOOTH PAGE TRANSITION
      // ==========================================
      body: Obx(() {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, anim) {
            return FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0.05, 0.02),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            );
          },
          child: _loadPage(controller.pageIndex.value),
        );
      }),

      // ==========================================
      // FLOATING GLASS NAV BAR (ICON AUTO ANIMATE)
      // ==========================================
      bottomNavigationBar: Obx(() {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
          child: GlassEffects.dynamicGlass(
            animation: const AlwaysStoppedAnimation(1),
            maxBlur: 30,
            minBlur: 12,
            borderRadius: BorderRadius.circular(28),
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),

                // ★ PREMIUM GLASS BACKGROUND
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.20),
                    Colors.white.withOpacity(0.10),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                // ★ BORDER ILLUSION
                border: Border.all(
                  color: Colors.white.withOpacity(0.28),
                  width: 1.3,
                ),

                // ★ DROP SHADOW (Floating)
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 25,
                    spreadRadius: 1,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.10),
                    blurRadius: 10,
                    offset: const Offset(-2, -2),
                  ),
                ],
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: _animatedNavBar(controller),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ==========================================
  // CUSTOM NAV BAR WITH ANIMATED ICONS
  // ==========================================
  Widget _animatedNavBar(MainController controller) {
    final items = [
      (CupertinoIcons.home, "Beranda"),
      (CupertinoIcons.qrcode_viewfinder, "Scan"),
      (CupertinoIcons.check_mark_circled, "Hadir"),
      (CupertinoIcons.timer, "Belum"),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(items.length, (i) {
        final isActive = controller.pageIndex.value == i;

        return GestureDetector(
          onTap: () => controller.changePage(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 230),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal: isActive ? 18 : 10,
              vertical: isActive ? 8 : 6,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withOpacity(0.25)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),

            child: Row(
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: isActive ? 1.25 : 1.0,
                  child: Icon(
                    items[i].$1,
                    color: isActive
                        ? Colors.black.withOpacity(0.85) // ★ FIX
                        : Colors.black.withOpacity(0.55), // ★ FIX
                    size: isActive ? 26 : 23,
                  ),
                ),

                if (isActive) ...[
                  const SizedBox(width: 6),
                  Text(
                    items[i].$2,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.85), // ★ FIX
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
