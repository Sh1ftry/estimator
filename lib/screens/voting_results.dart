import 'dart:async';

import 'package:estimator/constants.dart';
import 'package:estimator/models/vote.dart';
import 'package:estimator/services/estimation_service.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/double_button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/results.dart';
import 'package:estimator/widgets/text.dart';
import 'package:estimator/widgets/two_color_text.dart';
import 'package:estimator/widgets/votes.dart';
import 'package:flutter/widgets.dart';

class VotingResults extends StatefulWidget {
  VotingResults({Key key, this.isHost}) : super(key: key);

  final bool isHost;

  @override
  _VotingResultsState createState() => _VotingResultsState();
}

class _VotingResultsState extends State<VotingResults> {
  EstimationService _server = EstimationService();
  StreamSubscription<String> taskStreamSubscription;
  StreamSubscription<int> hostLeftStreamSubscription;

  String _task = "";
  String _sessionCode = "";

  void _nexTask() {
    Navigator.popUntil(context, ModalRoute.withName('/tasks'));
  }

  void _revote() {
    _server.changeTask(_task);
  }

  void _leave() {
    _server.disconnect();
    Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
  }

  @override
  void initState() {
    super.initState();
    _server.sessionCode.take(1).listen((sessionCode) {
      setState(() {
        _sessionCode = sessionCode;
      });
    });
    taskStreamSubscription = _server.task.listen((task) {
      if(_task.isEmpty) {
        setState(() {
          _task = task;
        });
      } else {
        Navigator.pop(context);
      }
    });
    hostLeftStreamSubscription = _server.hostLeft.listen((votes) {
      _leave();
    });
  }

  @override
  void dispose() {
    taskStreamSubscription.cancel();
    hostLeftStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<EstimatorVote> _results =
        ModalRoute.of(context).settings.arguments;
    return EstimatorLayout(widgets: [
      Padding(
        padding: TOP_PADDING,
        child: EstimatorTwoColorText(
          firstText: 'session code ',
          secondText: _sessionCode,
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
          text: _task,
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
                  results: _results,
                  mainColor: DARK_GREEN,
                  secondaryColor: LIGHT_GRAY),
            ),
          ],
        ),
      ),
      widget.isHost
          ? EstimatorDoubleButton(
              leftText: 'Revote',
              leftOnPressed: () => {_revote()},
              rightText: 'Next task',
              rightOnPressed: () => {_nexTask()},
            )
          : Container(),
      EstimatorButton(
        text: 'Leave',
        bottomMargin: BOTTOM_MARGIN,
        onPressed: () => {_leave()},
      )
    ]);
  }
}
