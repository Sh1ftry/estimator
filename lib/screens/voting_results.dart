import 'package:estimator/constants.dart';
import 'package:estimator/models/vote.dart';
import 'package:estimator/models/voting_arguments.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/double_button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/results.dart';
import 'package:estimator/widgets/text.dart';
import 'package:estimator/widgets/two_color_text.dart';
import 'package:estimator/widgets/votes.dart';
import 'package:flutter/widgets.dart';

class VotingResults extends StatefulWidget {
  @override
  _VotingResultsState createState() => _VotingResultsState();
}

class _VotingResultsState extends State<VotingResults> {
  final ScrollController _scrollController = ScrollController();

  final _results = [
    EstimatorVote("Michał", "3"),
    EstimatorVote("Adam", "3"),
    EstimatorVote("Wojtek", "2"),
    EstimatorVote("Florian", "5")
  ];

  @override
  Widget build(BuildContext context) {
    final VotingArguments votingArguments =
        ModalRoute.of(context).settings.arguments;
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
          text: votingArguments.task,
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
              results: _results,
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
      votingArguments.isHost ? EstimatorDoubleButton(
        leftText: 'Revote',
        leftOnPressed: () => {Navigator.pop(context)},
        rightText: 'Next task',
        rightOnPressed: () => {
          Navigator.popUntil(context, ModalRoute.withName('/tasks'))
        },
      ) : Container(),
      EstimatorButton(
        text: 'Leave',
        bottomMargin: BOTTOM_MARGIN,
        onPressed: () => {Navigator.pop(context)},
      )
    ]);
  }
}