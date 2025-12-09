import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';

import 'home_controller.dart';
import '../../widgets/attendance_chart.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ===========================================
          // PREMIUM GLASS BACKGROUND (iOS style)
          // ===========================================
          GlassEffects.dynamicGlass(
            animation: const AlwaysStoppedAnimation(1),
            maxBlur: 45,
            minBlur: 15,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0A0F1C),
                    Color(0xFF111827),
                    Color(0xFF1C263A),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // BOKEH LIGHTS
          Positioned(top: -60, left: -40, child: _bokeh(180, Colors.blue)),
          Positioned(
            bottom: -50,
            right: -30,
            child: _bokeh(210, Colors.purple),
          ),

          // ===========================================
          // SCROLL CONTENT
          // ===========================================
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dashboard Kehadiran",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.7,
                    ),
                  ),

                  Obx(
                    () => Text(
                      controller.eventName.value,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // =====================================
                  // GLASS CARDS
                  // =====================================
                  Obx(() {
                    return Column(
                      children: [
                        _glassStatCardPro(
                          title: "Total Wali Murid",
                          value: controller.totalWali.value,
                          color: CupertinoColors.activeBlue,
                        ),
                        const SizedBox(height: 10),
                        _glassStatCardPro(
                          title: "Sudah Hadir",
                          value: controller.totalHadir.value,
                          color: CupertinoColors.activeGreen,
                        ),
                        const SizedBox(height: 10),
                        _glassStatCardPro(
                          title: "Belum Hadir",
                          value: controller.totalBelumHadir,
                          color: CupertinoColors.systemRed,
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 25),

                  // =====================================
                  // CHART WRAPPER
                  // =====================================
                  GlassEffects.dynamicGlass(
                    animation: const AlwaysStoppedAnimation(1),
                    maxBlur: 18,
                    minBlur: 6,
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.white.withOpacity(0.06),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Obx(
                        () => AttendanceChart(
                          hadir: controller.totalHadir.value,
                          belum: controller.totalBelumHadir,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      "Data diperbarui otomatis",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BEAUTIFUL BOKEH
  Widget _bokeh(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.45),
            color.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  // PREMIUM GLASS CARD
  Widget _glassStatCardPro({
    required String title,
    required int value,
    required Color color,
  }) {
    return GlassEffects.dynamicGlass(
      animation: const AlwaysStoppedAnimation(1),
      maxBlur: 32,
      minBlur: 12,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white.withOpacity(0.08),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
