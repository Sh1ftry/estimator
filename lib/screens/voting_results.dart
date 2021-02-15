import 'package:estimator/constants.dart';
import 'package:estimator/models/vote.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/double_button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/results.dart';
import 'package:estimator/widgets/text.dart';
import 'package:estimator/widgets/two_color_text.dart';
import 'package:estimator/widgets/votes.dart';
import 'package:flutter/widgets.dart';

class VotingResults extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final results = [
    EstimatorVote("Michał", "3"),
    EstimatorVote("Adam", "3"),
    EstimatorVote("Wojtek", "2"),
    EstimatorVote("Florian", "5")
  ];

  @override
  Widget build(BuildContext context) {
    return EstimatorLayout(widgets: [
      Padding(
        padding: TOP_PADDING,
        child: EstimatorTwoColorText(
          firstText: 'session code ',
          secondText: 'xkd11',
          firstTextColor: LIGHT_GRAY,
          secondTextColor: DARK_GREEN,
        ),
      ),
      Padding(
        padding: TOP_PADDING,
        child: EstimatorText(
          text: 'finished voting on',
          color: LIGHT_GRAY,
        ),
      ),
      Padding(
        padding: HORIZONTAL_PADDING,
        child: EstimatorText(
          text:
          'ID-177 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque maximus.',
          color: DARK_GREEN,
        ),
      ),
      Padding(
        padding: TOP_PADDING,
        child: EstimatorText(
          text: 'votes',
          color: LIGHT_GRAY,
        ),
      ),
      Expanded(
        child: Column(
          children: [
            EstimatorVotes(
              results: results,
              mainColor: DARK_GREEN,
              secondaryColor: LIGHT_GRAY,
            ),
            Padding(
              padding: TOP_PADDING,
              child: EstimatorResults(
                  mean: "3.6",
                  median: "3",
                  mainColor: DARK_GREEN,
                  secondaryColor: LIGHT_GRAY),
            ),
          ],
        ),
      ),
      EstimatorDoubleButton(
        leftText: 'Revote',
        leftOnPressed: () => {Navigator.pop(context)},
        rightText: 'Next task',
        rightOnPressed: () => {Navigator.pop(context)},
      ),
      EstimatorButton(
        text: 'Leave',
        bottomMargin: 60,
        onPressed: () => {Navigator.pop(context)},
      )
    ]);
  }
}