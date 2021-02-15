import 'package:estimator/constants.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/grid.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/text.dart';
import 'package:estimator/widgets/two_color_text.dart';
import 'package:flutter/widgets.dart';

class TaskVoting extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final int votes = 3;
  final int maxVotes = 5;
  final List<String> estimates = ["0", "1", "2", "3", "5", "8"];

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
          text: 'voting on',
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
        child: EstimatorTwoColorText(
          firstText: 'votes',
          secondText: ' $votes/$maxVotes',
          firstTextColor: LIGHT_GRAY,
          secondTextColor: DARK_GREEN,
        ),
      ),
      EstimatorGrid(values: estimates),
      EstimatorButton(
        text: 'Leave',
        bottomMargin: 60,
        onPressed: () => {Navigator.pop(context)},
      )
    ]);
  }
}