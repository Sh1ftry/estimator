import 'dart:async';

import 'package:estimator/constants.dart';
import 'package:estimator/services/estimation_service.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/grid.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/text.dart';
import 'package:estimator/widgets/two_color_text.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskVoting extends StatefulWidget {
  const TaskVoting({Key key, this.isHost}) : super(key: key);

  final bool isHost;

  @override
  _TaskVotingState createState() => _TaskVotingState();
}

class _TaskVotingState extends State<TaskVoting> {
  int _votes = 0;
  List<String> _estimates = [];
  int _selected = -1;
  String _task = "";
  String _sessionCode = "";
  int _usersCount = 1;

  EstimationService _server = EstimationService();
  StreamSubscription<String> taskStreamSubscription;
  StreamSubscription<int> usersCountStreamSubscription;
  StreamSubscription<int> votesCountStreamSubscription;
  StreamSubscription<List> resultsStreamSubscription;
  StreamSubscription<int> hostLeftStreamSubscription;

  @override
  void initState() {
    super.initState();
    _server.sessionCode.take(1).listen((sessionCode) {
      setState(() {
        _sessionCode = sessionCode;
      });
    });
    _server.estimates.take(1).listen((estimates) {
      print(estimates);
      setState(() {
        _estimates = estimates;
      });
    });
    resultsStreamSubscription = _server.results.listen((results) {
      final routeName = widget.isHost ? '/results/host' : '/results/user';
      Navigator.pushNamed(context, routeName, arguments: results);
      _selected = -1;
    });
    taskStreamSubscription = _server.task.listen((task) {
      setState(() {
        if(task != _task) {
          _selected = -1;
        }
        _task = task;
      });
    });
    usersCountStreamSubscription = _server.maxVotes.listen((usersCount) {
      setState(() {
        _usersCount = usersCount;
      });
    });
    votesCountStreamSubscription = _server.votes.listen((votes) {
      setState(() {
        _votes = votes;
      });
    });
    hostLeftStreamSubscription = _server.hostLeft.listen((votes) {
      _leave();
    });
  }

  @override
  void dispose() {
    taskStreamSubscription.cancel();
    usersCountStreamSubscription.cancel();
    votesCountStreamSubscription.cancel();
    resultsStreamSubscription.cancel();
    super.dispose();
  }

  _leave() {
    if(widget.isHost) {
      _server.vote("");
    } else {
      _server.disconnect();
    }
    Navigator.pop(context, "left");
  }

  @override
  Widget build(BuildContext context) {
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
          text: 'voting on',
          color: LIGHT_GRAY,
        ),
      ),
      Padding(
        padding: HORIZONTAL_PADDING,
        child: EstimatorText(
          text: _task.isEmpty ? "waiting for host to select task" : _task,
          color: DARK_GREEN,
        ),
      ),
      Padding(
        padding: TOP_PADDING,
        child: EstimatorTwoColorText(
          firstText: 'votes',
          secondText: ' $_votes/$_usersCount',
          firstTextColor: LIGHT_GRAY,
          secondTextColor: DARK_GREEN,
        ),
      ),
      EstimatorGrid(
        values: _estimates,
        selected: _selected,
        onPressed: (index) => {
          setState(() {
            if (_selected == index || _task.isEmpty) {
              _selected = -1;
              _server.vote("");
            } else {
              _selected = index;
              _server.vote(_estimates[index]);
            }
          })
        },
      ),
      widget.isHost
          ? EstimatorButton(
              text: 'Finish voting',
              onPressed: () => {_server.finishVoting()},
            )
          : Container(),
      EstimatorButton(
        text: widget.isHost ? 'Go back' : 'Leave',
        bottomMargin: BOTTOM_MARGIN,
        onPressed: () => {_leave()},
      )
    ]);
  }
}
