
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'Constants.dart';

class KazinoWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Constants.init(context);

    return PlatformScaffold(
        body: SafeArea(
            child: PageView(
              controller: PageController(initialPage: 0),
              children: <Widget>[
                _buildNextButton("Intro Page"),
                _buildNextButton("Login Page"),
              ],
            )
        )
    );
  }

  Widget _buildNextButton(String text) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: FlatButton(child: Text(text))
    );
  }
}
