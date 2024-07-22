import 'package:flutter/material.dart';

class DevotionsState with ChangeNotifier {
  final PageController controller = PageController();

  void nextPage() async {
    await controller.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  void previousPage() async {
    await controller.previousPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }
}
