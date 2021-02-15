import 'package:flutter/widgets.dart';

class EstimatorTwoColorText extends StatelessWidget {
  EstimatorTwoColorText({
    Key key,
    this.firstText,
    this.firstTextColor,
    this.secondText,
    this.secondTextColor,
  });

  final String firstText;
  final Color firstTextColor;
  final String secondText;
  final Color secondTextColor;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: firstText,
        style: TextStyle(
            fontFamily: 'HemiHead', fontSize: 24.0, color: firstTextColor),
        children: <TextSpan>[
          TextSpan(text: secondText, style: TextStyle(color: secondTextColor)),
        ],
      ),
    );
  }
}
