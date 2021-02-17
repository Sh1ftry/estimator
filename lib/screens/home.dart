import 'package:estimator/constants.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/logo.dart';
import 'package:flutter/widgets.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EstimatorLayout(
      widgets: [
        EstimatorLogo(),
        EstimatorButton(
            text: 'Start a new session',
            onPressed: () => {Navigator.pushNamed(context, '/start')}),
        EstimatorButton(
            text: 'Join a session',
            onPressed: () => {Navigator.pushNamed(context, '/join')}),
        EstimatorButton(
          text: 'Configuration',
          bottomMargin: BOTTOM_MARGIN,
          onPressed: () => {Navigator.pushNamed(context, '/config')},
        )
      ],
    );
  }
}
