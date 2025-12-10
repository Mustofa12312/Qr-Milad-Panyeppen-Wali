import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../widgets/attendance_result_card.dart';
import 'scan_controller.dart';

class ScanView extends GetView<ScanController> {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    final double camSize = MediaQuery.of(context).size.width * 0.80;

    return Scaffold(
      extendBodyBehindAppBar: true,

      // =========================================================
      // APPBAR PREMIUM – TITLE + FLASH + SWITCH CAMERA
      // =========================================================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 4),
              const Text(
                "Scan QR Wali",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              // Row tombol flash & switch kamera (tengah)
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Flash
                    _glassIcon(
                      icon: controller.isFlashOn.value
                          ? CupertinoIcons.bolt_fill
                          : CupertinoIcons.bolt_slash_fill,
                      color: controller.isFlashOn.value
                          ? Colors.amberAccent
                          : Colors.white,
                      onTap: controller.toggleFlash,
                    ),
                    const SizedBox(width: 16),
                    // Switch kamera depan/belakang
                    _glassIcon(
                      icon: CupertinoIcons.camera_rotate,
                      color: Colors.white,
                      onTap: controller.switchCamera,
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: Stack(
        alignment: Alignment.center,
        children: [
          // BACKGROUND GRADIENT
          Container(
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

          // =====================================================
          // KONTEN UTAMA – SEMUANYA SIMETRIS TENGAH
          // =====================================================
          Column(
            children: [
              const Spacer(),

              // ======================== CAMERA VIEW ========================
              Container(
                width: camSize,
                height: camSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Kamera
                      MobileScanner(
                        controller: controller.cameraController,
                        onDetect: controller.handleBarcodeCapture,
                      ),

                      // Overlay gelap tipis
                      Container(color: Colors.black.withOpacity(0.18)),

                      // Frame & animasi
                      _scanFrame(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ======================== STATUS TOAST ========================
              Obx(() => _statusToast()),

              const SizedBox(height: 18),

              // ======================== RESULT CARD ========================
              Obx(() {
                final g = controller.lastGuardian.value;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: g == null
                      ? const SizedBox()
                      : Padding(
                          key: const ValueKey("resultCard"),
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: AttendanceResultCard(guardian: g),
                        ),
                );
              }),

              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // GLASS ICON BUTTON (Flash & Switch Camera)
  // =========================================================
  Widget _glassIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: 1.0,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.20),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }

  // =========================================================
  // ANIMATED SCAN FRAME (scale + glow halus)
  // =========================================================
  Widget _scanFrame() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutBack,
      builder: (_, scale, __) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: Colors.white.withOpacity(0.9),
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.18),
                  blurRadius: 26,
                ),
              ],
            ),
            child: _animatedScanLine(),
          ),
        );
      },
    );
  }

  // =========================================================
  // SCAN LINE ANIMATION (garis bergerak vertikal)
  // =========================================================
  Widget _animatedScanLine() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -1, end: 1),
      duration: const Duration(milliseconds: 1600),
      curve: Curves.easeInOut,
      onEnd: () {},
      builder: (context, value, child) {
        return Align(
          alignment: Alignment(0, value),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 26),
            height: 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.85),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // =========================================================
  // STATUS TOAST (Fade + Slide halus)
  // =========================================================
  Widget _statusToast() {
    final c = Get.find<ScanController>();

    if (c.statusMessage.value.isEmpty) return const SizedBox();

    final color = _statusColor(c.scanStatus.value);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: Container(
        key: ValueKey<String>(c.statusMessage.value),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.22),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_statusIcon(c.scanStatus.value), color: color, size: 18),
            const SizedBox(width: 10),
            Text(
              c.statusMessage.value,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (c.isProcessing.value) ...[
              const SizedBox(width: 10),
              const CupertinoActivityIndicator(radius: 8),
            ],
          ],
        ),
      ),
    );
  }

  // =========================================================
  // STATUS ICON + COLOR
  // =========================================================
  IconData _statusIcon(ScanStatus status) {
    switch (status) {
      case ScanStatus.success:
        return CupertinoIcons.check_mark_circled_solid;
      case ScanStatus.notFound:
      case ScanStatus.error:
        return CupertinoIcons.clear_circled_solid;
      default:
        return CupertinoIcons.info_circle_fill;
    }
  }

  Color _statusColor(ScanStatus status) {
    switch (status) {
      case ScanStatus.success:
        return CupertinoColors.activeGreen;
      case ScanStatus.error:
      case ScanStatus.notFound:
        return CupertinoColors.systemRed;
      default:
        return CupertinoColors.systemGrey;
    }
  }
}
