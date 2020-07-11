import 'package:kazino/WidgetExtensions.dart';

enum CellStateType {
  none, orange, yellow, lightBlue
}

class CellState {
  CellStateType type = CellStateType.none;
  int countAsHot = 0;
  int lastProgressPosition = 0;
}

class ProgressState{
  CellStateType type;
  int value;

  ProgressState(this.type, this.value);
}

class Counter {
  static Counter shared = Counter();

  final _hotRange = 50;
  final _coldRange = 50;
  final _minCountAsHot = 3;
  final _yellowRange = 37;
  final _minCountForYellow = 2;

  List<ProgressState> progressList = [];
  List<CellState> states = List.generate(38, (index) => CellState());
  List<int> skippedLine = List.generate(3, (index) => 0);
  List<int> skippedDozen = List.generate(3, (index) => 0);
  var isBingo38 = true;


  void add(int num) {
    var type = states[num - 1].type;
    progressList.insert(0, ProgressState(type, num));
    _updateStates();
    if(type != CellStateType.lightBlue) {
      progressList[0] = ProgressState(states[num - 1].type, num);
    }
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
      var pos = progressList[i].value - 1;
      if (!(i >= _hotRange && i >= _coldRange && i >= _yellowRange)) {
        states[pos].countAsHot++;
        if (states[pos].countAsHot >= _minCountAsHot) {
          states[pos].type = CellStateType.orange;
        } else if (states[pos].countAsHot >= _minCountForYellow && i < _yellowRange) {
          states[pos].type = CellStateType.yellow;
        }
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
      final skip = progressList.indexWhere((item) => item.value < 37 && (3 - (item.value % 3)) % 3 + 1 == line);
      return skip == -1 ? progressList.length : skip;
    });
    skippedDozen.fill((dozen) {
      final skip = progressList.indexWhere((item) => (item.value + 11) ~/ 12 == dozen);
      return skip == -1 ? progressList.length : skip;
    });
  }

  void _reset(CellState state) {
    state.type = CellStateType.none;
    state.countAsHot = 0;
    state.lastProgressPosition = -1;
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