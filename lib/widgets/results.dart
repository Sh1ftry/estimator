import 'package:estimator/widgets/two_color_text.dart';
import 'package:flutter/widgets.dart';

class EstimatorResults extends StatelessWidget {
  EstimatorResults({
    Key key,
    this.mean,
    this.median,
    this.mainColor,
    this.secondaryColor,
  }) : super(key: key);

  final Color mainColor;
  final Color secondaryColor;
  final String mean;
  final String median;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        EstimatorTwoColorText(
          firstText: 'median\n',
          secondText: median,
          firstTextColor: mainColor,
          secondTextColor: secondaryColor,
        ),
        EstimatorTwoColorText(
          firstText: 'mean\n',
          secondText: mean,
          firstTextColor: mainColor,
          secondTextColor: secondaryColor,
        ),
      ],
    );
  }
}
