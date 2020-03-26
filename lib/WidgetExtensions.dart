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
}