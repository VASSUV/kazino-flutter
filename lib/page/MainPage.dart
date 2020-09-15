
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moneywheel/NoAnimationPageRoute.dart';
import 'package:moneywheel/domain/Counter.dart';
import 'package:moneywheel/domain/Settings.dart';
import 'package:moneywheel/page/SettingsPage.dart';

import 'MainBloc.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _bloc = MainBloc();
  var opacity = 1.0;
  static Duration get duration => Duration(seconds: 1);
  final opacityStream = Stream.periodic(duration);

  @override
  void initState() {
    super.initState();
    opacityStream.listen((event) {
      setState(() {
        opacity = opacity == 1 ? 0.6 : 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: StreamBuilder(
              stream: _bloc.output.stream,
              builder: (context, snapshot) => Row(
                children: [
                  _buildList(),
                  Expanded(child: _buildWorkArea()),
                ],
              ),
            )
        )
    );
  }

  Widget _buildList() {
    return AnimatedContainer (
      width: Counter.shared.progressList.length == 0 ? 0 : MediaQuery.of(context).size.width/4,
      duration: Duration(milliseconds: 400),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Container(
          color: Colors.black.withAlpha(240),
          width: MediaQuery.of(context).size.width/4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric (vertical: 8.0),
                child: RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric (vertical: 8.0),
                    child: Text("Вернуть\n1 ход", textAlign: TextAlign.center),
                  ), onPressed: _bloc.undo,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: Counter.shared.progressList.length,
                    itemBuilder: (context, index) => _buildListItem(index)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkArea() {
    return Container (
      color: Colors.black,
      child: Stack(
        children: [
          Column(
            children: [
              Spacer(),
              Expanded(flex: 10, child: _buildLogo()),
              Spacer(),
              for(int i = 0; i < 7; i++)  _buildRowItem(i),
              Spacer()
            ]
          ),
          Align(
            alignment: Alignment.topRight,
            child: Builder(
              builder: (context) => IconButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).push(TransparentRoute(
                    builder: (context) => SettingsPage(
                      clean: _bloc.clean,
                    )
                )
                ),
                icon: Icon(Icons.settings),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Builder(
              builder: (context) => Row(
                children: [
                  IconButton(
                    color: Settings().isSafety ? Colors.green : Colors.red,
                    onPressed: () {},
                    icon: Icon(Icons.error_outline),
                  ),
                  Text(
                      Settings().isSafety ? "Безопасный режим" : "Не безопасный режим",
                      style: TextStyle(color: Settings().isSafety ? Colors.green : Colors.red)
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: AnimatedOpacity(
        opacity: opacity,
        duration: duration,
        curve: Curves.linear,
        child: Padding(
            padding: EdgeInsets.all(16),
            child: Image.asset("assets/logo.png")
        ),
      ),
    );
  }

  Widget _buildListItem(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCountText(Counter.shared.progressList.length - index - 1, scale: 0.9),
        _buildItem(Counter.shared.progressList[index], scale: 0.8),
      ],
    );
  }

  Widget _buildRowItem(int i) {
    return Material(
      color: Colors.black,
      child: InkWell(
        onTap: () => _bloc.onTap(i),
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCountText(Counter.shared.states[i].hot),
                _buildItem(i, scale: 1.5),
                _buildCountText(Counter.shared.states[i].cold)
              ],
            ),
            if(i == 4) _buildBet(i)
          ],
        ),
      ),
    );
  }

  Widget _buildBet(int i) {
    final hot = Counter.shared.states[i].hot;
    final bet = Settings().bet(hot);
    return Padding(
      padding: const EdgeInsets.only(left: 36.0),
      child: Opacity(
            opacity: bet == 0 ? 0 : 1,
            child: Container(
              padding: EdgeInsets.all(4.0),
              decoration: new BoxDecoration(
                color: Colors.teal,
                border: Border.all(color: Colors.black, width: 0.0),
                borderRadius: new BorderRadius.all(Radius.elliptical(50,50)),
              ),
              child: Text(bet.toString(),
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
            ),
      ),
    );
  }

  Widget _buildCountText(int count, {double scale = 1}) {
    return Container(
        width: 60 * scale,
        height: 32 * scale,
      child: Center(
        child: Text(
          count <= 0 ? '-' : count.toString(),
          style: TextStyle(
              fontSize: 18 * scale,
              fontWeight: FontWeight.bold,
              color: Colors.white
          )
        )
      )
    );
  }

  Widget _buildItem(int position, {double scale = 1}) {
    return Container(
      width: 24 * scale,
      height: 32 * scale,
      margin: EdgeInsets.all(8),
      child: Stack(
        children: [
          Transform(
            transform: (Matrix4.identity()
              ..setEntry(3, 2, 0.01)
              ..rotateX(pi / 6)),
            alignment: FractionalOffset.center,
            child: Container(
              color: Counter.colors[position],
            )
          ),
          Center(
            child: Text(
                Counter.nums[position].toString(),
              style: TextStyle(
                fontSize: 18 * scale,
                  fontWeight: FontWeight.bold,
                  color: Counter.textColors[position]
              )
            )
          )
        ]
      )
    );
  }
}