
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:kazino/page/SettingsPage.dart';
import 'package:kazino/page/TablePage.dart';

import 'Constants.dart';

class KazinoWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Constants.init(context);

    return Scaffold(
        body: SafeArea(
            child: PageView(
              controller: PageController(initialPage: 0),
              children: <Widget>[
                TablePage(),
                SettingsPage(),
              ],
            )
        )
    );
  }
}
