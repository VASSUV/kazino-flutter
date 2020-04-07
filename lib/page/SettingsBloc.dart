
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

  void onChangeRow(int row) {
    BettingDictionary.bettSelected = row;
    _output.add(null);
  }
}