import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ContextRoute on BuildContext {
  Function routerTo<T extends StatelessWidget>(T page) {
    return () {
      Navigator.of(this).push(CupertinoPageRoute(builder: (context) {
        return page;
      }));
    };
  }

  Function routerTo2<T extends StatefulWidget>(T page) {
    return () {
      Navigator.of(this).push(CupertinoPageRoute(builder: (context) {
        return page;
      }));
    };
  }
}

extension WidgetExtension on Widget {
  Widget sizedWidth(int scale) { // %
    int flexScale = ((100 - scale) ~/ 2).toInt();
    return Row(
      children: <Widget>[
        Spacer(flex: flexScale,),
        Expanded(flex: scale, child: this),
        Spacer(flex: flexScale,),
      ]
    );
  }

  Widget row(List<Widget> childs) {
    return Row(children: childs);
  }

  Widget column(List<Widget> childs) {
    return Column(children: childs);
  }
}

extension ListExtension<T> on List<T> {
  void fill(T func(int line)) {
    for (int i = 0; i < this.length; i++) {
      this[i] = func(i+1);
    }
  }
}

extension StreamExtension on Stream {
  Widget wrap(Widget Function() f) => StreamBuilder(stream: this, builder: (c, s) => f());
}