import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazino/domain/Counter.dart';
import 'package:kazino/page/BettingDictionary.dart';
import 'package:kazino/widget/Button.dart';

import 'SettingsBloc.dart';

class SettingsPage extends StatelessWidget {
  SettingsBloc _bloc = SettingsBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.update,
      builder: (context, snapshot) {
        return ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text("Настройки",
                      textAlign: TextAlign.center, textScaleFactor: 3),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Button(title: "Очистить", onPressed: () {
                      _showDialog(context, "Очистка поля", "Состояние прохождения нельзя будет вернуть, очистить поле?", _bloc.onClearChanged);
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Button(title: "Сменить режим", onPressed: () {
                      _showDialog(context, "Смена режима", "Прохождение будет сброшено и режим будет сменен на ${Counter.shared.isBingo38 ? 37 : 38} чисел, сменить режим?", _bloc.onChange);
                    }),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text("Последовательности")
                    )
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: Opacity(opacity: 0)),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Button(title: "№ 1", enabled: BettingDictionary.bettSelected == 2, onPressed: () {
                           _bloc.onChangeRow(1);
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Button(title: "№ 2", enabled: BettingDictionary.bettSelected == 1, onPressed: () {
                          _bloc.onChangeRow(2);
                        }),
                      ),
                      Expanded(child: Opacity(opacity: 0))
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      }
    );
  }

  void _showDialog(BuildContext context, String title, String description, Function onApply) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            FlatButton(
              child: Text("Да"),
              onPressed: () {
                Navigator.of(context).pop();
                onApply();
              }),
          ],
        );
      },
    );
  }

//
//  StreamBuilder _buildSliderDescription() {
//    return StreamBuilder(
//        stream: _bloc.sliderChange,
//        builder: (context, snapshot) {
//          return Text("${_bloc.sliderValue.round()}", textScaleFactor: 2, textAlign: TextAlign.center);
//        });
//  }
//  StreamBuilder _buildTwiceCheckBox() {
//    return StreamBuilder(
//        stream: _bloc.twiceChange,
//        builder: (context, snapshot) {
//          return Row(children: <Widget>[
//            Checkbox(value: _bloc.twiceValue, onChanged: _bloc.onTwiceChanged),
//            Text(
//              "Показывать числа выпавшие 2 раза за 37 ходов в течении 37 ходов",
//            )
//          ]);
//        });
//  }
//
//  StreamBuilder _buildHotCheckBox() {
//    return StreamBuilder(
//        stream: _bloc.hotChange,
//        builder: (context, snapshot) {
//          return Row(children: <Widget>[
//            Checkbox(value: _bloc.hotValue, onChanged: _bloc.onHotChanged),
//            Text(
//              "Показывать горячие числа (3 и более выпадений за 50 ходов)",
//            )
//          ]);
//        });
//  }
//
//  StreamBuilder _buildSlider() {
//    return StreamBuilder(
//        stream: _bloc.sliderChange,
//        builder: (context, snapshot) {
//          return Slider(
//              value: _bloc.sliderValue,
//              min: 15.0,
//              max: 100.0,
//              activeColor: Colors.red,
//              inactiveColor: Colors.black,
//              label: '${_bloc.sliderValue} f',
//              onChanged: _bloc.onSliderChanged,
//              semanticFormatterCallback: (double newValue) {
//                return '${newValue.round()} 8';
//              });
//        });
//  }
}
