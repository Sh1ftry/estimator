import 'dart:math';

import 'package:estimator/models/vote.dart';
import 'package:estimator/widgets/two_color_text.dart';
import 'package:flutter/widgets.dart';

class EstimatorResults extends StatelessWidget {
  EstimatorResults({
    Key key,
    this.results,
    this.mainColor,
    this.secondaryColor,
  }) : super(key: key);

  final Color mainColor;
  final Color secondaryColor;
  final List<EstimatorVote> results;

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  Widget build(BuildContext context) {
    String median;
    String mean;
    bool areNumbers = results.every((element) => isNumeric(element.vote));
    if (areNumbers) {
      List<double> numbers = results.map((e) => double.parse(e.vote)).toList();
      numbers.sort((a, b) => a.compareTo(b));
      mean = (numbers.reduce((a, b) => a + b) / results.length).toString();
      int middle = (numbers.length / 2).floor();
      if (numbers.length % 2 == 0) {
        median = ((numbers[middle] + numbers[middle - 1]) / 2).toString();
      } else {
        median = numbers[middle].toString();
      }
    }
    Map<String, int> elementToCount = new Map();
    results.map((e) => e.vote).forEach((element) {
      elementToCount[element] = (elementToCount[element] ?? 0) + 1;
    });
    print(elementToCount);
    int maxCount = elementToCount.values.reduce(max);
    List<String> modes = elementToCount.entries
        .where((element) => element.value == maxCount)
        .map((e) => e.key.toString())
        .toList();
    List<Widget> widgets = [];
    if (areNumbers) {
      widgets.add(EstimatorTwoColorText(
        firstText: 'median\n',
        secondText: median,
        firstTextColor: mainColor,
        secondTextColor: secondaryColor,
      ));
      widgets.add(EstimatorTwoColorText(
        firstText: 'mean\n',
        secondText: mean,
        firstTextColor: mainColor,
        secondTextColor: secondaryColor,
      ));
    }
    widgets.add(EstimatorTwoColorText(
      firstText: 'mode\n',
      secondText: modes.join(", "),
      firstTextColor: mainColor,
      secondTextColor: secondaryColor,
    ));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widgets,
    );
  }
}
