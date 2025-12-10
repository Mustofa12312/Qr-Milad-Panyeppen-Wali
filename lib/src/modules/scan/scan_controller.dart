import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../data/models/guardian.dart';
import '../../data/services/supabase_service.dart';

enum ScanStatus { idle, success, notFound, error }

class ScanController extends GetxController {
  ScanController({required this.supabaseService, required this.eventName});

  final SupabaseService supabaseService;
  final String eventName;

  /// Kamera controller
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  // Reactive states
  final RxBool isProcessing = false.obs;
  final RxBool isFlashOn = false.obs;
  final RxBool isFrontCamera = false.obs;

  final Rx<Guardian?> lastGuardian = Rx<Guardian?>(null);
  final Rx<ScanStatus> scanStatus = ScanStatus.idle.obs;
  final RxString statusMessage = ''.obs;

  // =============================================================
  //  FLASH (TORCH)
  // =============================================================
  Future<void> toggleFlash() async {
    try {
      await cameraController.toggleTorch();
      isFlashOn.value = !isFlashOn.value;
    } catch (e) {
      scanStatus.value = ScanStatus.error;
      statusMessage.value = "Flash gagal digunakan.";
    }
  }

  // =============================================================
  //  SWITCH CAMERA
  // =============================================================
  Future<void> switchCamera() async {
    try {
      await cameraController.switchCamera();

      isFrontCamera.value = !isFrontCamera.value;

      // Matikan flash saat pindah kamera biar aman
      isFlashOn.value = false;
    } catch (e) {
      scanStatus.value = ScanStatus.error;
      statusMessage.value = "Kamera gagal diganti.";
    }
  }

  // =============================================================
  //  HANDLE BARCODE / QR
  // =============================================================
  Future<void> handleBarcodeCapture(BarcodeCapture capture) async {
    if (isProcessing.value) return; // cegah double scan

    final barcode = capture.barcodes.firstOrNull;
    final raw = barcode?.rawValue;

    if (raw == null) {
      _showError("QR tidak terbaca.");
      return;
    }

    int id;
    try {
      id = int.parse(raw.trim());
    } catch (_) {
      _showError("Format QR salah (bukan angka).");
      return;
    }

    if (id < 1 || id > 1500) {
      _showError("ID di luar rentang 1–1500.");
      return;
    }

    isProcessing.value = true;

    try {
      final guardian = await supabaseService.getGuardianById(id);

      if (guardian == null) {
        _showNotFound("Data untuk ID $id tidak ditemukan.");
        return;
      }

      // Insert attendance
      await supabaseService.insertAttendance(
        guardianId: guardian.idWali,
        eventName: eventName,
      );

      lastGuardian.value = guardian;
      scanStatus.value = ScanStatus.success;
      statusMessage.value = "Absensi berhasil: ${guardian.namaWali}";

      // Notify other controllers automatically
      _triggerGlobalRefresh();
    } catch (e) {
      _showError("Kesalahan: $e");
    } finally {
      isProcessing.value = false;
    }
  }

  // =============================================================
  //  GLOBAL REFRESH SIGNAL
  // =============================================================
  void _triggerGlobalRefresh() {
    /// Kirim event agar Home, Hadir, Tidak Hadir ikut update
    if (Get.isRegistered(tag: "globalRefresh")) {
      Get.find<RxBool>(tag: "globalRefresh").toggle();
    }
  }

  // =============================================================
  //  ERROR HELPERS
  // =============================================================
  void _showNotFound(String msg) {
    lastGuardian.value = null;
    scanStatus.value = ScanStatus.notFound;
    statusMessage.value = msg;
  }

  void _showError(String msg) {
    lastGuardian.value = null;
    scanStatus.value = ScanStatus.error;
    statusMessage.value = msg;
  }

  // =============================================================
  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
