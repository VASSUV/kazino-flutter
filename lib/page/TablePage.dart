
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'TableBloc.dart';

class TablePage extends StatelessWidget {

  TableBloc _bloc = TableBloc();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            _buildZero(),
            _buildOneThird(0),
            _buildOneThird(1),
            _buildOneThird(2),
            _buildRows(),
          ],
        )
    );
  }

  Widget _buildZero() {
    return Expanded(
      flex: 1,
      child: Column(
        children: <Widget>[
          _buildSpace(),
          _build(0, flex: 3),
          _buildSpace()
        ],
      ),
    );
  }


  Widget _build(int index, { int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.all(1.0),
        child: Container(
            color: Colors.green,
            child: Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('$index'),
              ),
            )),
      ),
    );
  }
  
  Widget _buildSpace() {
    return Expanded(flex: 1, child: Opacity(opacity: 0));
  }

  Widget _buildOneThird(int index) {
    return Expanded(
      flex: 4,
      child: Column(
        children: <Widget>[
          _build(-1),
          _buildRow(3 + 12 * index),
          _buildRow(2 + 12 * index),
          _buildRow(1 + 12 * index),
          _buildExtra()
        ],
      ),
    );
  }

  Widget _buildRow(int index) {
    var widgets = <Widget>[];
    for (int i = 0; i < 4; i++) {
      widgets.add(_build(index + i * 3));
    }
    return Expanded(flex: 1, child: Row(children: widgets));
  }

  Widget _buildExtra() {
    return Expanded(
      flex: 1,
      child: Row(children: <Widget>[
        _build(-1),
        _build(-1)
      ]),
    );
  }

  Widget _buildRows() {
    return Expanded(
      flex: 2,
      child: Column(
        children: <Widget>[
          _buildSpace(),
          _build(-1),
          _build(-1),
          _build(-1),
          _buildSpace()
        ],
      ),
    );
  }
}
