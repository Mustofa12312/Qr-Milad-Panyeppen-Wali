import 'package:get/get.dart';

class MainController extends GetxController {
  final pageIndex = 0.obs;

  void changePage(int index) {
    pageIndex.value = index;
  }
}
