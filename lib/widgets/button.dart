import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EstimatorButton extends StatelessWidget {
  const EstimatorButton({
    Key key,
    this.text,
    this.bottomMargin = 15.0,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final double bottomMargin;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: ButtonTheme(
        height: 80.0,
        buttonColor: const Color.fromARGB(255, 54, 191, 177),
        child: RaisedButton(
          onPressed: onPressed,
          child: FittedBox(
            child: Text(
              text,
              style: TextStyle(
                  fontFamily: 'HemiHead',
                  fontSize: 24.0,
                  color: const Color.fromARGB(255, 4, 53, 64)),
            ),
          ),
        ),
      ),
    );
  }
}
