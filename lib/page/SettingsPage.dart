import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsPage extends StatefulWidget {

  final void Function() undo;
  final void Function() clean;

  const SettingsPage({Key key, this.undo, this.clean}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(color: Colors.white.withAlpha(40))
              ),
              Row(
                  children: [
                    Expanded(child: Opacity(opacity: 0), flex: 1),
                    Expanded(child: _buildWorkArea(), flex: 2),
                  ],
                ),
            ],
          )
    );
  }

  Widget _buildWorkArea() {
    return Stack(
      children: [
        Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(color: Colors.black),
              ),
              Expanded(flex: 10, child: _buildSettingsArea()),
              Spacer(),
              Container(height: 48.0 * 7),
              Spacer()
            ]
        ),
        Align(
          alignment: Alignment.topRight,
          child: Material(
            color: Colors.black,
            child: Builder(
              builder: (context) => IconButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSettingsArea() {
    final style = TextStyle(color: Colors.white);
    Widget undoButton = FlatButton(
      child: Text("Вернуть ход", style: style),
      onPressed: () {
        widget.undo();
        Navigator.of(context).pop();
      },
    );
    Widget cleanButton = FlatButton(
      child: Text("Сбросить", style: style),
      onPressed: () {
        Widget okButton = FlatButton(
          child: Text("OK"),
          onPressed: () {
            widget.clean();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
        Widget cancelButton = FlatButton(
          child: Text("Отменить"),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );

        AlertDialog alert = AlertDialog(
          title: Text("Сброс прогресса"),
          content: Text("Прогресс уничтожится безвозвратно, продолжить?"),
          actions: [okButton, cancelButton],
        );

        showDialog(
          context: context,
          builder: (context) => alert,
        );
      },
    );
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Opacity(opacity: 0, child: Image.asset("assets/logo.png")),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(child: Column(children: [undoButton, cleanButton])),
          )
        ],
      )
    );
  }
}
