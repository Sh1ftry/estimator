import 'package:estimator/constants.dart';
import 'package:estimator/models/voting_arguments.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/grid.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/text.dart';
import 'package:estimator/widgets/two_color_text.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskVoting extends StatefulWidget {
  @override
  _TaskVotingState createState() => _TaskVotingState();
}

class _TaskVotingState extends State<TaskVoting> {
  final ScrollController _scrollController = ScrollController();

  int _votes = 0;
  final int _maxVotes = 1;
  List<String> _estimates = [];
  int _selected = -1;

  @override
  void initState() {
    super.initState();
    _loadEstimates();
  }

  _loadEstimates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _estimates = prefs.getString('estimates').split(" ");
    });
  }

  _navigateToResults(votingArguments) async {
    await Navigator.pushNamed(
      context,
      '/results',
      arguments: votingArguments,
    );
    setState(() {
      _votes = 0;
      _selected = -1;
    });
  }

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
          text: 'voting on',
          color: LIGHT_GRAY,
        ),
      ),
      Padding(
        padding: HORIZONTAL_PADDING,
        child: EstimatorText(
          text: votingArguments.task.isEmpty ? "waiting for host to select task" : votingArguments.task,
          color: DARK_GREEN,
        ),
      ),
      Padding(
        padding: TOP_PADDING,
        child: EstimatorTwoColorText(
          firstText: 'votes',
          secondText: ' $_votes/$_maxVotes',
          firstTextColor: LIGHT_GRAY,
          secondTextColor: DARK_GREEN,
        ),
      ),
      EstimatorGrid(
        values: _estimates,
        selected: _selected,
        onPressed: (index) => {
          setState(() {
            if (_selected == index || votingArguments.task.isEmpty) {
              _selected = -1;
            } else {
              _selected = index;
            }
          })
        },
      ),
      votingArguments.isHost
          ? EstimatorButton(
              text: 'Finish voting',
              onPressed: () => {
                _navigateToResults(votingArguments)
              },
            )
          : Container(),
      EstimatorButton(
        text: votingArguments.isHost ? 'Go back' : 'Leave',
        bottomMargin: BOTTOM_MARGIN,
        onPressed: () => {Navigator.pop(context, "left")},
      )
    ]);
  }
}
