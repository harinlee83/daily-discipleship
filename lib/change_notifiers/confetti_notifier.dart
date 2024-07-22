import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ConfettiNotifier with ChangeNotifier {
  final ConfettiController controllerTop =
      ConfettiController(duration: const Duration(seconds: 1));

  void playConfetti() {
    controllerTop.play();
    notifyListeners();
  }
}
