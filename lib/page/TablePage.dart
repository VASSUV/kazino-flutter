import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kazino/domain/Counter.dart';
import 'package:kazino/page/BettingDictionary.dart';
import 'package:kazino/widget/CustomBorder.dart';

import '../Constants.dart';
import '../WidgetExtensions.dart';
import 'TableBloc.dart';

class TablePageSizes {
  double cellWidth;
  double cellText;
  double cellTextSkip;
  double bingoesText;
  double radius;
  double stepText;
  double badge;

  TablePageSizes() {
    cellWidth = Constants.width / 15.5;
    cellText = cellWidth / 2.5;
    cellTextSkip = cellWidth / 3;
    radius = cellWidth / 10;
    stepText = cellWidth / 2;
    bingoesText =  Counter.shared.isBingo38 ? cellWidth / 4 : cellWidth / 3;
    badge = cellWidth / 2;
  }
}

class TablePage extends StatelessWidget {

  final _bloc = TableBloc();
  final _sizes = TablePageSizes();

  final white = Colors.white;

  final side = BorderSide(
      width: 2, color: Colors.white, style: BorderStyle.solid);
  final borderAll = Border.all(
      width: 2, color: Colors.white, style: BorderStyle.solid);

  Radius get radius => Radius.circular(_sizes.radius);

  Opacity get _opacity => Opacity(opacity: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: <Widget>[
          _expanded(Align(alignment: Alignment.center, child:
          _bloc.cellUpdate.wrap(() =>
              _textTitle("Ход: ${_bloc.countProgress + 1}"))
          )),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                height: _sizes.cellWidth * 4,
                child: row(<Widget>[
                  _buildBingoes(),
                  _roundedWithoutTopLeftBlock(
                      _buildDozen(0), scaleY: 4, scaleX: 4),
                  Spacer(),
                  _roundedBlock(_buildDozen(1), scaleY: 4, scaleX: 4),
                  Spacer(),
                  _roundedBlock(_buildDozen(2), scaleY: 4, scaleX: 4),
                  Spacer(),
                  _buildRows()
                ],
                ),
              ),
            ),
          ),
          _expanded(Opacity(opacity: 0,)),
          _buildProgressList()
        ],
      ),
    );
  }

  Widget _expanded(Widget widget) => Expanded(child: widget);
  Widget _buildVerticalSide() => Container(width: 2, color: white);
  Widget _buildHorizontalSide() => Container(height: 2, color: white);

  Text _textTitle(String text) => Text(text, style: TextStyle(
          fontSize: _sizes.stepText,
          fontWeight: FontWeight.w500,
          color: Colors.white));

  Text _textCell(int index) => Text('$index', style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w300,
      fontSize: _sizes.cellText));

  Text _textDozen(int start, int end) => Text("$start - $end",
      style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.w300,
        fontSize: _sizes.cellTextSkip));

  Text _textBingo(int index, double textSize) => Text("Bingo $index",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w300,
        fontSize: textSize));

  Text _textSkipped(int skipped) => Text("${skipped > 0 ? skipped : ''}",
      style: TextStyle(
          color: Colors.black45,
          fontWeight: FontWeight.w600,
          fontSize: _sizes.cellTextSkip));

  RichText _textLine(int line, double size) {
    return RichText(text: TextSpan(children: [
      TextSpan(text: "$line", style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: size / 2.6)
      ),
      TextSpan(
          text: " LINE",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: size / 5
          )
      )
    ]));
  }

  Widget _buildBingoes() {
    var widgets = <Widget>[ _buildZeroCell(37, _sizes.bingoesText)];
    if (_bloc.isBingo38) {
      widgets.insert(0, _buildHorizontalSide());
      widgets.insert(0, _buildZeroCell(38, _sizes.bingoesText));
    }
    return column(<Widget>[
      _leftBlock(column(widgets), scaleY: 3)
    ]);
  }

  Widget _buildRows() {
    return column(<Widget>[
      _expanded(_buildRow(1)),
      _expanded(_buildRow(2)),
      _expanded(_buildRow(3)),
      _expanded(_opacity)
    ]);
  }

  Widget _buildRow(int line) {
    final size = _sizes.cellWidth - 4;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
          height: size,
          width: size * 1.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(size / 2)),
            border: borderAll,
            color: Colors.green,
          ),
          child: Stack(
            children: <Widget>[
              Center(
                child: column(<Widget>[
                  _expanded(_opacity),
                  _textLine(line, size),
                  _bloc.cellUpdate.wrap(() {
                    return _textSkipped(_bloc.skippedInLine(line));
                  }),
                  _expanded(_opacity),
                ]),
              ),
              _bloc.cellUpdate.wrap(() => _buildBetting(line))
            ],
          )
      ),
    );
  }


  Widget _buildBetting(int line) {
    int skipped = _bloc.skippedInLine(line);
    var bett = BettingDictionary.betting(skipped);
    if (skipped > 0 && bett != null) {
      return _bettBadge(bett, Alignment.topRight);
    } else {
      return _opacity;
    };
  }

  Widget _bettBadge(String bett, Alignment alignment) {
    return Align(alignment: alignment, child: Container(
        height: _sizes.badge, width: _sizes.badge,
        child: CustomPaint(painter: ShapesPainter(text: bett))
    ));
  }

  Widget _buildDozen(int dozen) {
    final start = dozen * 12 + 1;
    return column(<Widget>[
      _buildFour(start + 2),
      _buildHorizontalSide(),
      _buildFour(start + 1),
      _buildHorizontalSide(),
      _buildFour(start),
      _buildHorizontalSide(),
      _expanded(_buildDozenCell(dozen + 1))
    ]);
  }


  Widget _buildFour(int position) => _expanded(row(<Widget>[
    _expanded(_bloc.cellUpdate.wrap(() => _buildCell(position))),
    _buildVerticalSide(),
    _expanded(_bloc.cellUpdate.wrap(() => _buildCell(position + 3))),
    _buildVerticalSide(),
    _expanded(_bloc.cellUpdate.wrap(() => _buildCell(position + 6))),
    _buildVerticalSide(),
    _expanded(_bloc.cellUpdate.wrap(() => _buildCell(position + 9))),
  ]));

  Widget _buildCell(int index) {
    var cell = _bloc.cellState(index);
    return Material(
      color: cell.type.color,
      child: InkWell(
        onTap: () => _bloc.onTapCell(index),
        child: Center(
            child: column(<Widget>[
              _expanded(_opacity),
              _textCell(index),
              _textSkipped(cell.lastProgressPosition),
              _expanded(_opacity)
            ])
        ),
      ),
    );
  }


  Widget _buildDozenCell(int dozen) {
    final start = (dozen - 1) * 12 + 1;
    final end = start + 11;
    final size = min(Constants.width, Constants.height) / 6;
    return Stack(children: <Widget>[
      Container(color: Colors.green),
      Center(
          child: column(<Widget>[
            _expanded(_opacity),
            _textDozen(start, end),
            _bloc.cellUpdate.wrap(() => _textSkipped(_bloc.skippedDozen(dozen))),
            _expanded(_opacity),
          ],
          )
      ),
      _bloc.cellUpdate.wrap(() {
        int skipped = _bloc.skippedDozen(dozen);
        var bett = BettingDictionary.betting(skipped);
        if (skipped > 0 && bett != null) {
          return Padding(
            padding: EdgeInsets.only(right: size / 3),
            child: _bettBadge(bett, Alignment.centerRight),
          );
        } else {
          return _opacity;
        }
      })
    ]);
  }


  Widget _buildZeroCell(int index, double textSize) {
    return _expanded(_bloc.cellUpdate.wrap(() {
      final cell = _bloc.cellState(index);
      return Material(
        color: _bloc.cellState(index).type.color,
        child: InkWell(
          onTap: () => _bloc.onTapCell(index),
          child: Center(child: row(<Widget>[
            _expanded(_opacity),
            RotatedBox(quarterTurns: 3, child: _textBingo(index, textSize)),
            RotatedBox(quarterTurns: 3, child: _textSkipped(cell.lastProgressPosition)),
            _expanded(_opacity)
          ])),
        ),
      );
    }));
  }

  Widget _roundedBlock(Widget widget, {double scaleX = 1, double scaleY = 1}) {
    return Container(
      width: _sizes.cellWidth * scaleX,
      height: _sizes.cellWidth * scaleY,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(radius),
          border: borderAll
      ),
      child: widget,
    );
  }

  Widget _roundedWithoutTopLeftBlock(Widget widget, {double scaleX = 1, double scaleY = 1}) {
    return Container(
      width: _sizes.cellWidth * scaleX,
      height: _sizes.cellWidth * scaleY,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: radius, bottomLeft: radius, bottomRight: radius),
          border: borderAll
      ),
      child: widget,
    );
  }

  Widget _leftBlock(Widget widget, {double scaleX = 1, double scaleY = 1}) {
    return Container(
      width: _sizes.cellWidth * scaleX,
      height: _sizes.cellWidth * scaleY,
      decoration: ShapeDecoration(
          shape: CustomBorder(borderWidth: 2,
              borderRadius: BorderRadius.only(
                  topLeft: radius, bottomLeft: radius))
      ),
      child: widget,
    );
  }

  bool _isRed(int num, int start, int end) {
    return num >= start && num <= end && num % 2 == start % 2;
  }

  Widget _buildProgressList() {
    final height = min(Constants.width, Constants.height) / 6;
    return Container(
        height: height,
        color: Colors.grey,
        child: row(<Widget>[
          _expanded(_bloc.cellUpdate.wrap(() =>
              ListView.builder(
                  itemCount: _bloc.countProgress,
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildProgressItem(index, height);
                  }
              )
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: _bloc.onBackPressed,
              child: Icon(Icons.undo),
            ),
          )
        ])
    );
  }

  Container _buildProgressItem(int index, double height) {
    final cell = _bloc.progressCell(index);
    final value = cell.value;
    Widget numberWidget;
    final size = height / 4;
    Color color = Colors.white;
    Color textColor = Colors.white;
    Alignment alignment = Alignment.center;

    if (value >= 37) {
      textColor = Colors.black;
    } else if (_isRed(value, 1, 9) || _isRed(value, 12, 18) ||
        _isRed(value, 19, 27) || _isRed(value, 30, 36)) {
      alignment = Alignment.topCenter;
      color = Colors.red;
    } else {
      alignment = Alignment.bottomCenter;
      color = Colors.black;
    }
    final decoration = BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
            Radius.circular(size / 2))
    );

    numberWidget = Align(alignment: alignment,
        child: Container(
            width: size,
            height: size,
            decoration: decoration,
            child: Center(
              child: Text("${cell.value}",
                  style: TextStyle(
                      color: textColor, fontSize: height / 6)),
            )));


    return Container(
      width: height / 3,
      child: column(<Widget>[
        Container(
            margin: EdgeInsets.symmetric(vertical: 2),
            color: cell.type.progressColor,
            width: height / 9,
            height: height / 9
        ),
        _expanded(numberWidget),
        Text("${_bloc.countProgress - index}",
            style: TextStyle(fontSize: height / 6)),
      ]),
    );
  }
}

class ShapesPainter extends CustomPainter {
  final String text;

  ShapesPainter({this.text});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.deepOrange;
    var center = Offset(size.width / 2, size.height / 3);

    canvas.drawOval(Rect.fromCenter(center: center, width: size.width * 2, height: size.width), paint);

    final textStyle = TextStyle(color: Colors.white, fontSize: size.width/1.8);
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr, textAlign: TextAlign.center);
    textPainter.layout(minWidth: size.width * 2, maxWidth: size.width * 2);
    textPainter.paint(canvas, Offset(-size.width/2, 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}