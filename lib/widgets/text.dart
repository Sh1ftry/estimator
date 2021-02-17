import 'package:flutter/widgets.dart';

class EstimatorText extends StatelessWidget {
  EstimatorText({Key key, this.text, this.color, this.size = 24.0})
      : super(key: key);

  final String text;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontFamily: 'HemiHead', fontSize: size, color: color),
    );
  }
}
