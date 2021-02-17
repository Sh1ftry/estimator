import 'package:estimator/constants.dart';
import 'package:flutter/widgets.dart';

class EstimatorLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 114.0),
        child: Text(
          "Estimator",
          style: TextStyle(
            fontFamily: 'HemiHead',
            fontSize: 65.0,
            color: VERY_DARK_GREEN,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
