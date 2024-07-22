import 'package:flutter/material.dart';

class HealthState with ChangeNotifier {
  final PageController controller = PageController();

  final Map<String, int> fruitOfTheSpiritState = {
    "Love": 0,
    "Joy": 0,
    "Peace": 0,
    "Patience": 0,
    "Kindness": 0,
    "Goodness": 0,
    "Faithfulness": 0,
    "Gentleness": 0,
    "Self-Control": 0,
  };

  updateFoSCount(String fruit, int count) {
    fruitOfTheSpiritState[fruit] = count;
    // debugPrint("Love: ${fruitOfTheSpiritState["Love"].toString()}");
    // debugPrint("Joy: ${fruitOfTheSpiritState["Joy"].toString()}");
    // debugPrint("Peace: ${fruitOfTheSpiritState["Peace"].toString()}");
    // debugPrint("Patience: ${fruitOfTheSpiritState["Patience"].toString()}");
    // debugPrint("Kindness: ${fruitOfTheSpiritState["Kindness"].toString()}");
    // debugPrint("Goodness: ${fruitOfTheSpiritState["Goodness"].toString()}");
    // debugPrint("Faithfulness: ${fruitOfTheSpiritState["Faithfulness"].toString()}");
    // debugPrint("Gentleness: ${fruitOfTheSpiritState["Gentleness"].toString()}");
    // debugPrint("Self-Control: ${fruitOfTheSpiritState["Self-Control"].toString()}");
    notifyListeners();
  }

  void nextPage() async {
    await controller.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }
}
