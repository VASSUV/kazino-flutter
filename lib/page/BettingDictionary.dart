import 'dart:math';

import 'package:flutter/cupertino.dart';

class BettingDictionary {

  static List<int> _betts = [
    0, 0, 0, 0, 0, 0, 0, 500, 500, 100,
    1500, 2000, 3000, 4500, 7000, 10500, 17500, 23000, 35000
  ];

  static String betting(int skipped) {
    int bett = _betting(skipped);
    if (bett >= 1000) {
      double value = bett / 1000;
      if (value >= 1000) {
        value = value / 1000;
        return "${value - value.toInt() > 0 ? value.toStringAsFixed(1) : value.toInt()}M";
      }
      return "${value - value.toInt() > 0 ? value.toStringAsFixed(1) : value.toInt()}K";
    } else if (bett > 0) {
      return "$bett";
    } else {
      return null;
    }
  }

  static int _betting(int skipped) {
    if (skipped < 0) {
      return 0;
    } else if (skipped < _betts.length) {
      return _betts[skipped];
    } else {
      return _betts.last;
    }
  }
}