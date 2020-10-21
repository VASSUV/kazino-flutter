import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moneywheel/domain/AppModel.dart';
import 'package:moneywheel/domain/Counter.dart';
import 'package:moneywheel/domain/Settings.dart';

import 'AdminPage.dart';

class SettingsPage extends StatefulWidget {

  final void Function() clean;

  const SettingsPage({Key key, this.clean}) : super(key: key);

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
                    Container(width: Counter.shared.progressList.length == 0 ? 0 : MediaQuery.of(context).size.width / 4),
                    Expanded(child: _buildWorkArea()),
                  ],
                ),
            ],
          )
    );
  }

  Widget _buildWorkArea() {
    return Stack(
      children: [
        _buildSettingsArea(),
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
            child: Center(child: Column(children: [
              SizedBox(height: 40),
              Material(
                color: Settings().isSafety ? Colors.green[100] : Colors.red[100],
                  child: SwitchListTile(
                    activeColor: Colors.green,
                    activeTrackColor: Colors.green[200],
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red[200],
                    title: Text(Settings().isSafety ? "Безопасно" : "Не безопасно"),
                    value: Settings().isSafety,
                    onChanged: (value) {
                      setState(() {
                        Settings().isSafety = value;
                      });
                    }
                  )
              ),
              SizedBox(height: 40),
              Material(
                color: Colors.transparent,
                child: ValueListenableBuilder(
                  valueListenable: AppModel.I.availableTypes,
                  builder: (context, value, child) {
                    return Column(
                      children: ProgressionType.values.reversed.map((e) =>
                          switchListTile(e)).toList()
                    );
                  }
                )
              ),
              SizedBox(height: 40),
              cleanButton,
              SizedBox(height: 40),
              if(AppModel.I.admin.value) adminButton()
            ])),
          )
        ],
      )
    );
  }

  Widget switchListTile(ProgressionType type) {
    var absorbing = !AppModel.I.availableTypes.value.contains(type);
    return AbsorbPointer(
      absorbing: absorbing,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: ColoredBox(
          color: absorbing ? Colors.grey[500] : Colors.white,
          child: CheckboxListTile(
              title: Text(progressionTitle(type)),
              onChanged: (bool value) {
                setState(() {
                  Settings().progressionType = type;
                });
              },
              value: type == Settings().progressionType),
        ),
      ),
    );
  }

  String progressionTitle(ProgressionType type) {
    switch(type) {
      case ProgressionType.VIP: { return "VIP зал"; }
      case ProgressionType.SITE: { return "Сайт"; }
    }
    return "Зал";
  }

  Widget adminButton() => Material(
    child: ListTile(
      title: Text("Админ Панель"),
      onTap: () => Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => AdminPage()
      )),
    ),
  );
}
