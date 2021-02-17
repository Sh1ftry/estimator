import 'package:estimator/models/vote.dart';
import 'package:estimator/widgets/two_color_text.dart';
import 'package:flutter/widgets.dart';

class EstimatorVotes extends StatelessWidget {
  EstimatorVotes({
    Key key,
    this.results,
    this.mainColor,
    this.secondaryColor,
  }) : super(key: key);

  final List<EstimatorVote> results;
  final Color mainColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    final resultsTexts = results
        .map<Widget>((result) => EstimatorTwoColorText(
              firstText: result.name,
              secondText: " ${result.result}",
              firstTextColor: mainColor,
              secondTextColor: secondaryColor,
            ))
        .toList();

    return Column(children: resultsTexts);
  }
}
