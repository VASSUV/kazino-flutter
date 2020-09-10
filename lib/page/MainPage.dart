
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moneywheel/NoAnimationPageRoute.dart';
import 'package:moneywheel/domain/Counter.dart';
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
                  Expanded(child: _buildList(), flex: 1),
                  Expanded(child: _buildWorkArea(), flex: 2),
                ],
              ),
            )
        )
    );
  }

  Widget _buildList() {
    return Container (
      color: Colors.black.withAlpha(240),
      child: ListView.builder(
          itemCount: Counter.shared.progressList.length,
          itemBuilder: (context, index) => _buildListItem(index)
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
                      undo: _bloc.undo,
                      clean: _bloc.clean,
                    )
                  )
                ),
                icon: Icon(Icons.settings),
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
        _buildCountText(Counter.shared.progressList.length - index - 1),
        _buildItem(Counter.shared.progressList[index]),
      ],
    );
  }

  Widget _buildRowItem(int i) {
    return Material(
      color: Colors.black,
      child: InkWell(
        onTap: () => _bloc.onTap(i),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCountText(Counter.shared.states[i].cold),
            _buildItem(i),
            _buildCountText(Counter.shared.states[i].hot)
          ],
        ),
      ),
    );
  }

  Widget _buildCountText(int count) {
    return Container(
        width: 80,
        height: 32,
      child: Center(
        child: Text(
          count <= 0 ? '-' : count.toString(),
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white
          )
        )
      )
    );
  }

  Widget _buildItem(int position) {
    return Container(
      width: 24,
      height: 32,
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
                fontSize: 18,
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