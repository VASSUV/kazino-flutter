
import 'dart:async';

import 'package:flutter/material.dart';

import '../domain/Counter.dart';

class TableBloc {
  final _outputCellController = StreamController.broadcast();
  Stream get cellUpdate => _outputCellController.stream;

  var _counter = Counter.shared;
  bool get isBingo38 => _counter.isBingo38;
  int get countProgress => _counter.progressList.length;

  CellState cellState(int index) => _counter.states[index-1];

  ProgressState progressCell(int index) => _counter.progressList[index];

  int skippedInLine(int line) => _counter.skippedLine[line - 1];

  int skippedDozen(int dozen) => _counter.skippedDozen[dozen - 1];

  void onTapCell(int index) {
    _counter.add(index);
    _outputCellController.sink.add(null);
  }

  void onBackPressed() {
    _counter.back();
    _outputCellController.sink.add(null);
  }
}

extension CellStateExtension on CellStateType {
  Color get color {
    switch (this) {
      case CellStateType.orange:
        return Colors.orange;
      case CellStateType.yellow:
        return Colors.yellow[600];
      case CellStateType.lightBlue:
        return Colors.lightBlue[700];
      default:
        return Colors.green;
    }
  }

  Color get progressColor {
    switch (this) {
      case CellStateType.orange:
        return Colors.orange;
      case CellStateType.yellow:
        return Colors.yellow[600];
      case CellStateType.lightBlue:
        return Colors.lightBlue[700];
      default:
        return Colors.transparent;
    }
  }
}