import 'package:estimator/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EstimatorLayout extends StatelessWidget {
  const EstimatorLayout({
    Key key,
    this.widgets,
  }) : super(key: key);

  final List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LIGHT_GREEN,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widgets,
          ),
        ));
  }
}
