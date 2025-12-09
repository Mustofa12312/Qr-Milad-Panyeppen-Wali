import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'present_controller.dart';

class PresentView extends GetView<PresentController> {
  const PresentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND BLUR PREMIUM
          GlassEffects.dynamicGlass(
            animation: const AlwaysStoppedAnimation(1),
            maxBlur: 45,
            minBlur: 18,
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
          Positioned(
            top: -60,
            left: -40,
            child: _bokeh(160, Colors.greenAccent),
          ),
          Positioned(
            bottom: -50,
            right: -30,
            child: _bokeh(190, Colors.blueAccent),
          ),

          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Yang Sudah Hadir",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CupertinoActivityIndicator());
                    }

                    if (controller.guardians.isEmpty) {
                      return const Center(
                        child: Text(
                          "Belum ada yang hadir.",
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      );
                    }

                    // =============================
                    // GROUP BY FIRST LETTER
                    // =============================
                    final Map<String, List<dynamic>> groups = {};
                    for (var g in controller.guardians) {
                      String first = g.namaWali[0].toUpperCase();
                      groups.putIfAbsent(first, () => []);
                      groups[first]!.add(g);
                    }
                    final sortedKeys = groups.keys.toList()..sort();

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: sortedKeys.length,
                      itemBuilder: (context, index) {
                        final key = sortedKeys[index];
                        final list = groups[key]!;

                        return Column(
                          children: [
                            // ======= GARIS PEMISAH (tanpa huruf) =======
                            if (index != 0)
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                height: 0.8,
                                width: double.infinity,
                                color: Colors.white.withOpacity(0.20),
                              ),

                            // ======= CARD PER DATA =======
                            ...list.map((g) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _glassPresentCard(
                                  name: g.namaWali,
                                  student: "${g.namaMurid} • ${g.kelasMurid}",
                                  id: g.idWali.toString(),
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // BOKEH EFFECT
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
  Widget _glassPresentCard({
    required String name,
    required String student,
    required String id,
  }) {
    return GlassEffects.dynamicGlass(
      animation: const AlwaysStoppedAnimation(1),
      maxBlur: 30,
      minBlur: 12,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.12),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.28), width: 1.2),
        ),

        child: Row(
          children: [
            GlassEffects.dynamicGlass(
              animation: const AlwaysStoppedAnimation(1),
              maxBlur: 12,
              minBlur: 6,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: CupertinoColors.activeGreen.withOpacity(0.25),
                ),
                child: const Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  color: CupertinoColors.activeGreen,
                  size: 26,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    student,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),

            // Text(
            //   "#$id",
            //   style: const TextStyle(
            //     fontSize: 15,
            //     fontWeight: FontWeight.bold,
            //     color: CupertinoColors.black,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
  // BOKEH EFFECT
  