import 'package:flutter/material.dart';

class TabDt with ChangeNotifier {
  PageController _pgc;

  int _currentIndex = 0;

  TabDt() {
    _pgc = new PageController(initialPage: _currentIndex);
    notifyListeners();
  }

  PageController get pgc => _pgc;

  int get currentIndex => _currentIndex;

  reviseCurrentIndex(int val) {
    _currentIndex = val;
    notifyListeners();
  }
}
