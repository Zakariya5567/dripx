import 'package:flutter/material.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int currentIndex = 1;

  setCurrentIndex(int newIndex) {
    // currentIndex = newIndex;
    currentIndex = 1;
    notifyListeners();
  }
}
