
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final Gradient gradient;
  final double width;
  final double height;
  final bool enabled;
  final Function onPressed;

  Gradient get disableGradient => LinearGradient(colors: [Colors.black12, Colors.black12]);

  const Button({
    Key key,
    this.title,
    this.gradient = const LinearGradient(colors: [Colors.blueGrey, Colors.grey]),
    this.width = 200.0,
    this.height = 50.0,
    this.enabled = true,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textWidget = Center(
      child: Text(title, style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold
      ),),
    );
    Widget content;
    if(enabled) {
      content = Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: textWidget
          )
      );
    } else {
      content = textWidget;
    }

    return Container( width: width, height: 50.0,
      decoration: BoxDecoration(
          gradient: enabled ? gradient : disableGradient,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(1.0, 2.0),
              blurRadius: 4.0,
            ),
          ]
      ),
      child: content
    );
  }
}