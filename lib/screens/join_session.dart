import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/logo.dart';
import 'package:estimator/widgets/text_field.dart';
import 'package:flutter/widgets.dart';

class JoinSession extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EstimatorLayout(widgets: [
      EstimatorLogo(),
      EstimatorTextField(hintText: 'Display name'),
      EstimatorTextField(hintText: 'Session code'),
      EstimatorButton(text: 'Join a session'),
      EstimatorButton(
        text: 'Go back',
        bottomMargin: 60,
        onPressed: () => {Navigator.pop(context)},
      )
    ]);
  }
}
