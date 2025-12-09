import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'absent_controller.dart';

class AbsentView extends GetView<AbsentController> {
  const AbsentView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedLetter = ''.obs;
    final showBubble = false.obs;

    final Map<String, GlobalKey> sectionKeys = {};

    return Scaffold(
      body: Stack(
        children: [
          // ================================
          // PREMIUM BLUR BACKGROUND
          // ================================
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

          // BOKEH
          Positioned(top: -60, left: -40, child: _bokeh(160, Colors.redAccent)),
          Positioned(
            bottom: -50,
            right: -30,
            child: _bokeh(190, Colors.orange),
          ),

          // ================================
          // CONTENT AREA
          // ================================
          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Yang Belum Hadir",
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
                          "Semua wali murid sudah hadir 🎉",
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      );
                    }

                    // =================================
                    // GROUP BY FIRST LETTER
                    // =================================
                    final Map<String, List<dynamic>> groups = {};
                    for (var g in controller.guardians) {
                      final name = g.namaWali.trim();
                      if (name.isEmpty) continue;
                      String first = name[0].toUpperCase();
                      groups.putIfAbsent(first, () => []);
                      groups[first]!.add(g);
                    }
                    final sortedKeys = groups.keys.toList()..sort();

                    for (var k in sortedKeys) {
                      sectionKeys.putIfAbsent(k, () => GlobalKey());
                    }

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
                          key: sectionKeys[key],
                          children: [
                            // Garis pemisah antar group (tanpa huruf)
                            if (index != 0)
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                height: 1,
                                width: double.infinity,
                                color: Colors.white.withOpacity(0.20),
                              ),

                            // CARD
                            ...list.map((g) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _glassAbsentCard(
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

          // ===================================
          // INDEX A–Z KANAN DENGAN ANIMASI
          // ===================================
          Positioned(
            right: 6,
            top: 0,
            bottom: 0,
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: sectionKeys.keys.map((letter) {
                  final isSelected = selectedLetter.value == letter;

                  return GestureDetector(
                    onTapDown: (_) {
                      selectedLetter.value = letter;
                      showBubble.value = true;

                      final ctx = sectionKeys[letter]!.currentContext;
                      if (ctx != null) {
                        Scrollable.ensureVisible(
                          ctx,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        );
                      }

                      Future.delayed(
                        const Duration(milliseconds: 600),
                        () => showBubble.value = false,
                      );
                    },
                    child: AnimatedScale(
                      scale: isSelected ? 1.7 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: isSelected ? 16 : 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ===================================
          // BUBBLE HURUF DI TENGAH
          // ===================================
          Obx(() {
            if (!showBubble.value || selectedLetter.value.isEmpty) {
              return const SizedBox();
            }
            return Center(
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  selectedLetter.value,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }),
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

  // GLASS CARD ABJAD
  Widget _glassAbsentCard({
    required String name,
    required String student,
    required String id,
  }) {
    return GlassEffects.dynamicGlass(
      animation: const AlwaysStoppedAnimation(1),
      maxBlur: 28,
      minBlur: 10,
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
                  color: CupertinoColors.systemRed.withOpacity(0.28),
                ),
                child: const Icon(
                  CupertinoIcons.clear_circled_solid,
                  color: CupertinoColors.systemRed,
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
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
