
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const Button({
    Key key,
    this.title,
    this.gradient = const LinearGradient(colors: [Colors.blueGrey, Colors.grey]),
    this.width = 110.0,
    this.height = 50.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container( width: width, height: 50.0,
      decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(1.0, 2.0),
              blurRadius: 4.0,
            ),
          ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Text(title, style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
            )),
      ),
    );
  }
}