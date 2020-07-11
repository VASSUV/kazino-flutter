
import 'dart:async';

import 'package:kazino/domain/Counter.dart';
import 'package:kazino/page/BettingDictionary.dart';

class SettingsBloc {
  var _output = StreamController.broadcast();
  Stream get update => _output.stream;

  void onClearChanged() {
    Counter.shared.reset();
  }

  void onChange() {
    Counter.shared.changeBingoState();
  }

  void bettStartChange(double value) {
    BettingDictionary.bettStart = value.toInt() - 1;
    _output.add(null);
  }
}