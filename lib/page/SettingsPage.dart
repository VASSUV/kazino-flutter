import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazino/widget/Button.dart';

import 'SettingsBloc.dart';

class SettingsPage extends StatelessWidget {
  SettingsBloc _bloc = SettingsBloc();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text("Настройки",
                  textAlign: TextAlign.center, textScaleFactor: 3),
              Row(
                children: <Widget>[
                  Spacer(),
                  Button(title: "Очистить", onPressed: () {}),
                  Spacer(),
                  Button(title: "Сохранить", onPressed: () {}),
                  Spacer(),
                  Button(title: "Открыть", onPressed: () {}),
                  Spacer()
                ],
              ),
              Container(height: 20),
              Text("Параметр для расчета холодных чисел, от 15 до 100", textAlign: TextAlign.center),
              _buildSlider(),
              _buildSliderDescription(),
              _buildHotCheckBox(),
              _buildTwiceCheckBox()
            ],
          ),
        ),
      ],
    );
  }

  StreamBuilder _buildSliderDescription() {
    return StreamBuilder(
        stream: _bloc.sliderChange,
        builder: (context, snapshot) {
          return Text("${_bloc.sliderValue.round()}", textScaleFactor: 2, textAlign: TextAlign.center);
        });
  }

  StreamBuilder _buildTwiceCheckBox() {
    return StreamBuilder(
        stream: _bloc.twiceChange,
        builder: (context, snapshot) {
          return Row(children: <Widget>[
            Checkbox(value: _bloc.twiceValue, onChanged: _bloc.onTwiceChanged),
            Text(
              "Показывать числа выпавшие 2 раза за 37 ходов в течении 37 ходов",
            )
          ]);
        });
  }

  StreamBuilder _buildHotCheckBox() {
    return StreamBuilder(
        stream: _bloc.hotChange,
        builder: (context, snapshot) {
          return Row(children: <Widget>[
            Checkbox(value: _bloc.hotValue, onChanged: _bloc.onHotChanged),
            Text(
              "Показывать горячие числа (3 и более выпадений за 50 ходов)",
            )
          ]);
        });
  }

  StreamBuilder _buildSlider() {
    return StreamBuilder(
        stream: _bloc.sliderChange,
        builder: (context, snapshot) {
          return Slider(
              value: _bloc.sliderValue,
              min: 15.0,
              max: 100.0,
              activeColor: Colors.red,
              inactiveColor: Colors.black,
              label: '${_bloc.sliderValue} f',
              onChanged: _bloc.onSliderChanged,
              semanticFormatterCallback: (double newValue) {
                return '${newValue.round()} 8';
              });
        });
  }
}
