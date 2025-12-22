import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'absent_controller.dart';

class AbsentView extends GetView<AbsentController> {
  const AbsentView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, GlobalKey> sectionKeys = {};

    return Scaffold(
      body: Stack(
        children: [
          // ==============================
          // BACKGROUND
          // ==============================
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

          // ==============================
          // CONTENT
          // ==============================
          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    "Yang Belum Hadir",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CupertinoActivityIndicator());
                    }

                    if (controller.filtered.isEmpty) {
                      return const Center(
                        child: Text(
                          "Semua wali sudah hadir 🎉",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      );
                    }

                    // ==============================
                    // GROUP BY HURUF AWAL
                    // ==============================
                    final Map<String, List<dynamic>> groups = {};
                    for (var g in controller.filtered) {
                      final name = g.namaWali.trim();
                      if (name.isEmpty) continue;

                      final letter = name[0].toUpperCase();
                      groups.putIfAbsent(letter, () => []);
                      groups[letter]!.add(g);
                    }

                    final keys = groups.keys.toList()..sort();
                    for (var k in keys) {
                      sectionKeys.putIfAbsent(k, () => GlobalKey());
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: keys.length,
                      itemBuilder: (context, index) {
                        final letter = keys[index];
                        final list = groups[letter]!;

                        return Column(
                          key: sectionKeys[letter],
                          children: [
                            if (index != 0)
                              Divider(
                                height: 20,
                                color: Colors.white.withOpacity(0.2),
                              ),

                            ...list.map(
                              (g) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _glassCard(
                                  name: g.namaWali,
                                  student: "${g.namaMurid} • ${g.kelasMurid}",
                                  id: g.idWali.toString(),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),

          // ==============================
          // INDEX A–Z
          // ==============================
          Positioned(
            right: 6,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: sectionKeys.keys.map((letter) {
                return Obx(() {
                  final isSelected = controller.selectedLetter.value == letter;

                  return GestureDetector(
                    onTapDown: (_) {
                      controller.selectedLetter.value = letter;
                      controller.showBubble.value = true;

                      final ctx = sectionKeys[letter]?.currentContext;
                      if (ctx != null) {
                        Scrollable.ensureVisible(
                          ctx,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        );
                      }

                      Future.delayed(
                        const Duration(milliseconds: 600),
                        () => controller.showBubble.value = false,
                      );
                    },
                    child: AnimatedScale(
                      scale: isSelected ? 1.6 : 1.0,
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
                });
              }).toList(),
            ),
          ),

          // ==============================
          // BUBBLE HURUF
          // ==============================
          Obx(() {
            if (!controller.showBubble.value ||
                controller.selectedLetter.value.isEmpty) {
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
                  controller.selectedLetter.value,
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

  // ==============================
  // CARD
  // ==============================
  Widget _glassCard({
    required String name,
    required String student,
    required String id,
  }) {
    return GlassEffects.dynamicGlass(
      animation: const AlwaysStoppedAnimation(1),
      maxBlur: 24,
      minBlur: 10,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.clear_circled_solid,
              color: CupertinoColors.systemRed,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
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
