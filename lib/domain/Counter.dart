import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moneywheel/WidgetExtensions.dart';

class CellState {
  int hot = -1;
  int cold = 0;
}

class Counter {

  static Counter shared = Counter();

  static List<int> nums = [
    48, 24, 16, 12,
    6, 4, 2
  ];

  static List<Color> colors = [
    Colors.yellow[600], Colors.red[600], Colors.pink[700], Colors.blue[800],
    Colors.green[600], Colors.cyan[400], Colors.grey[900]
  ];

  static List<Color> textColors = [
    Colors.red, Colors.yellow[700], Colors.white, Colors.white,
    Colors.white, Colors.white, Colors.white
  ];

  List<int> progressList = [];

  List<CellState> states = List.generate(nums.length, (index) => CellState());

  void add(int position) {
    progressList.insert(0, position);
    _updateStates();
  }

  void back() {
    if (progressList.length > 0) {
      progressList.removeAt(0);
      _updateStates();
    }
  }

  void _updateStates() {
    final maxCount = progressList.length;
    final length = min(100, maxCount);
    states.forEach((state) {
      state.hot = maxCount;
      state.cold = 0;
    });

    for(int i = 0; i < length; i ++) {
      var position = progressList[i];
      var state = states[position];
      state.hot = state.hot == maxCount ? i : state.hot;
      state.cold++;
    }
    for(int i = 100; i < maxCount; i ++) {
      var position = progressList[i];
      var state = states[position];
      state.hot = state.hot == maxCount ? i : state.hot;
    }
  }

  void clean() {
    progressList.clear();
    states.forEach((state) {
      state.hot = 0;
      state.cold = 0;
    });
    _updateStates();
  }
}