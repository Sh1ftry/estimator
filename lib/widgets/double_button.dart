import 'package:estimator/widgets/button.dart';
import 'package:flutter/widgets.dart';

class EstimatorDoubleButton extends StatelessWidget {
  EstimatorDoubleButton(
      {Key key,
        this.leftText,
        this.rightText,
        this.leftOnPressed,
        this.rightOnPressed})
      : super(key: key);

  final String leftText;
  final String rightText;
  final Function leftOnPressed;
  final Function rightOnPressed;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: EstimatorButton(
            text: leftText,
            onPressed: leftOnPressed,
          )),
      SizedBox(width: 15.0),
      Expanded(
          child: EstimatorButton(
            text: rightText,
            onPressed: rightOnPressed,
          )),
    ]);
  }
}