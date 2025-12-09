import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/models/guardian.dart';
import '../../data/services/supabase_service.dart';

enum ScanStatus { idle, success, notFound, error }

class ScanController extends GetxController {
  ScanController({required this.supabaseService, required this.eventName});

  final SupabaseService supabaseService;
  final String eventName;

  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  final RxBool isProcessing = false.obs;
  final RxBool isFlashOn = false.obs;
  final RxBool isFrontCamera = false.obs;

  final Rx<Guardian?> lastGuardian = Rx<Guardian?>(null);
  final Rx<ScanStatus> scanStatus = ScanStatus.idle.obs;
  final RxString statusMessage = ''.obs;

  // =============================================================
  // TOGGLE FLASH
  // =============================================================
  Future<void> toggleFlash() async {
    try {
      await cameraController.toggleTorch();
      isFlashOn.value = !isFlashOn.value;
    } catch (e) {
      statusMessage.value = "Flash gagal digunakan.";
      scanStatus.value = ScanStatus.error;
    }
  }

  // =============================================================
  // SWITCH CAMERA (BACK <-> FRONT)
  // =============================================================
  void switchCamera() {
    try {
      isFrontCamera.value = !isFrontCamera.value;
      cameraController.switchCamera();
    } catch (e) {
      statusMessage.value = "Tidak dapat mengganti kamera.";
      scanStatus.value = ScanStatus.error;
    }
  }

  // =============================================================
  // HANDLE SCAN
  // =============================================================
  Future<void> handleBarcodeCapture(BarcodeCapture capture) async {
    if (isProcessing.value) return;

    final barcode = capture.barcodes.firstOrNull;
    final rawValue = barcode?.rawValue;

    if (rawValue == null) {
      _showError("QR tidak terbaca.");
      return;
    }

    int id;
    try {
      id = int.parse(rawValue.trim());
    } catch (_) {
      _showError("Format QR salah.");
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

      await supabaseService.insertAttendance(
        guardianId: guardian.idWali,
        eventName: eventName,
      );

      lastGuardian.value = guardian;
      scanStatus.value = ScanStatus.success;
      statusMessage.value = "Absensi berhasil: ${guardian.namaWali}";
    } catch (e) {
      _showError("Kesalahan: $e");
    } finally {
      isProcessing.value = false;
    }
  }

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
