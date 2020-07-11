import 'dart:math';

class BettingDictionary {
  static var bettStart = 7;

  static List<int> _betts = [
    0, 200, 300, 500, 1000,
    1500, 2000, 3000, 4500, 7000, 10500, 17500, 23000
  ];

  static String _betting(int bett) {
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

  static String betting(int skipped) {
    final _skipped = max(skipped - bettStart, 0);
    final betts = _betts;
    return _betting(skipped < 0 ? 0 : (_skipped < betts.length ? betts[_skipped] : betts.last));
  }
}