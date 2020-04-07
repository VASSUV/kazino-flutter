import 'package:kazino/WidgetExtensions.dart';

enum CellStateType {
  none, orange, lightBlue
}

class CellState {
  CellStateType type = CellStateType.none;
  int countAsHot = 0;
  int lastProgressPosition = 0;
}

class Counter {
  static Counter shared = Counter();

  final _hotRange = 50;
  final _coldRange = 50;
  final _minCountAsHot = 3;

  List<int> progressList = [];
  List<CellState> states = List.generate(38, (index) => CellState());
  List<int> skippedLine = List.generate(3, (index) => 0);
  List<int> skippedDozen = List.generate(3, (index) => 0);
  var isBingo38 = true;


  void add(int num) {
    progressList.insert(0, num);
    _updateStates();
  }

  void back() {
    if (progressList.length > 0) {
      progressList.removeAt(0);
      _updateStates();
    }
  }

  void _updateStates() {
    states.forEach((state) => _reset(state));

    var tempPositions = List<int>.generate(38, (index) => index);
    for (var i = 0; i < progressList.length; i++) {
      var pos = progressList[i] - 1;
      if (i < _hotRange && i < _coldRange) {
        _increment(states[pos]);
      }
      final posInTempPositions = tempPositions.indexOf(pos);
      if (states[pos].lastProgressPosition == -1 && posInTempPositions >= 0) {
        states[pos].lastProgressPosition = i;
        tempPositions.removeAt(posInTempPositions);
        if(tempPositions.length == 0) {
          break;
        }
      }
    }
    if(tempPositions.length > 0) {
      tempPositions.forEach((pos) => states[pos].lastProgressPosition = progressList.length);
    }

    if(progressList.length >= _coldRange) {
      states.forEach((state) => _checkCold(state));
    }

    skippedLine.fill((int line) {
      final skip = progressList.indexWhere((num) => num < 37 && (3 - (num % 3)) % 3 + 1 == line);
      return skip == -1 ? progressList.length : skip;
    });
    skippedDozen.fill((dozen) {
      final skip = progressList.indexWhere((num) => (num + 11) ~/ 12 == dozen);
      return skip == -1 ? progressList.length : skip;
    });
  }

  void _reset(CellState state) {
    state.type = CellStateType.none;
    state.countAsHot = 0;
    state.lastProgressPosition = -1;
  }

  void _increment(CellState state) {
    state.countAsHot++;
    if (state.countAsHot >= _minCountAsHot) {
      state.type = CellStateType.orange;
    }
  }

  void _checkCold(CellState state) {
    if (state.countAsHot <= 0) {
      state.type = CellStateType.lightBlue;
    }
  }

  void reset() {
    progressList.clear();
    states.forEach((state) => _reset(state));
    skippedDozen = List.generate(3, (index) => 0);
    skippedLine = List.generate(3, (index) => 0);
  }

  void changeBingoState() {
    isBingo38 = !isBingo38;
    reset();
  }
}