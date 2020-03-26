import 'dart:io';

import 'package:flutter/widgets.dart';

class Constants {

  double _width = 0;
  double _height = 0;
  double _topSpace = 0;
  double _bottomSpace = 0;

  static double get width => _singleton._width;
  static double get height => _singleton._height;
  static double get topSpace => _singleton._topSpace;
  static double get bottomSpace => _singleton._bottomSpace;
  static bool isAndroid = Platform.isAndroid;
  static bool isIOS = Platform.isIOS;

  static Constants _singleton = Constants._default();

  static init(BuildContext context) {
    _singleton = Constants._init(context);
    _singleton._print();
  }

  Constants._default();

  Constants._init(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    _topSpace = MediaQuery.of(context).padding.top;
    _bottomSpace = MediaQuery.of(context).padding.bottom;
    _print();
  }

  _print() {
    print('Height = ' + Constants.height.toString());
    print('Width = ' + Constants.width.toString());
    print('Top = ' + Constants.topSpace.toString());
    print('Bottom = ' + Constants.bottomSpace.toString());
    print('isIos = ' + Constants.isIOS.toString());
    print('isAndroid = ' + Constants.isAndroid.toString());
  }
}