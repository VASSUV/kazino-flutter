import 'dart:math';

enum ProgressionType {
  VIP, SITE, DEFAULT
}

class Settings {
  static final Settings _singleton = Settings._internal();
  factory Settings() => _singleton;
  Settings._internal();

  var isSafety = true;
  var progressionType = ProgressionType.DEFAULT;
  int get _progressionTypeIndex => ProgressionType.values.indexOf(progressionType);
  int get bank => _minBank[_progressionTypeIndex];

  int bet(int index){
    final progressionIndex = _progressionTypeIndex;
    final progression = _progressions[progressionIndex];
    final minBetIndex = isSafety ? _minBetIndex[progressionIndex] : 0;
    return progression[max(0, min(progression.length - 1, index - minBetIndex))];
  }

  static const _progressions = [
    [0, 200, 200, 200, 200, 200, 300, 300, 400, 500, 600, 700, 800, 1000,
      1200, 1400, 1700, 2100, 2500, 3000, 3600, 4300, 5200, 6000],
    [0, 50, 50, 50, 50, 50, 100, 100, 100, 150, 150, 200, 250, 300, 350,
      400, 500, 600, 700, 850, 1000],
    [0, 50, 50, 50, 50, 50, 100, 100, 100, 150, 150, 200, 250, 300, 350,
      400, 500, 600, 700, 850, 1050, 1250, 1500, 1800, 2150, 2600, 3000]
  ];

  static const _minBetIndex = [17, 20, 14];

  static const _minBank = [75000, 14000,	37000];
}