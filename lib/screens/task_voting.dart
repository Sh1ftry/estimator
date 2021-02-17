import 'package:estimator/constants.dart';
import 'package:estimator/models/voting_arguments.dart';
import 'package:estimator/services/socket.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/grid.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/text.dart';
import 'package:estimator/widgets/two_color_text.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TaskVoting extends StatefulWidget {
  @override
  _TaskVotingState createState() => _TaskVotingState();
}

class _TaskVotingState extends State<TaskVoting> {
  final IO.Socket _socket = EstimatorServer().socket;

  VotingArguments _votingArguments;
  int _votes = 0;
  List<String> _estimates = [];
  int _selected = -1;

  @override
  void initState() {
    super.initState();
    _loadEstimates();
    _socket.on('changed', _changeTask);
    _socket.on('joined', _changeMaxUsers);
    _socket.on('user left', _changeMaxUsers);
    _socket.on('voted', _changeVotes);
  }

  @override
  void dispose() {
    _socket.off('changed', _changeTask);
    _socket.off('joined', _changeMaxUsers);
    _socket.off('user left', _changeMaxUsers);
    _socket.off('voted', _changeVotes);
    super.dispose();
  }

  _loadEstimates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _estimates = prefs.getString('estimates').split(" ");
    });
  }

  _navigateToResults(task, isHost, sessionCode) async {
    await Navigator.pushNamed(
      context,
      '/results',
      arguments: _votingArguments,
    );
    setState(() {
      _votes = 0;
      _selected = -1;
    });
  }

  _changeTask(task) {
    setState(() {
      _selected = -1;
      _votingArguments.task = task;
    });
  }

  _changeMaxUsers(usersCount) {
    setState(() {
      _votingArguments.voters = usersCount;
    });
  }

  _changeVotes(votes) {
    setState(() {
      _votes = votes;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_votingArguments == null) {
      _votingArguments = ModalRoute.of(context).settings.arguments;
    }

    return EstimatorLayout(widgets: [
      Padding(
        padding: TOP_PADDING,
        child: EstimatorTwoColorText(
          firstText: 'session code ',
          secondText: _votingArguments.sessionCode,
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
          text: _votingArguments.task.isEmpty ? "waiting for host to select task" : _votingArguments.task,
          color: DARK_GREEN,
        ),
      ),
      Padding(
        padding: TOP_PADDING,
        child: EstimatorTwoColorText(
          firstText: 'votes',
          secondText: ' $_votes/${_votingArguments.voters}',
          firstTextColor: LIGHT_GRAY,
          secondTextColor: DARK_GREEN,
        ),
      ),
      EstimatorGrid(
        values: _estimates,
        selected: _selected,
        onPressed: (index) => {
          setState(() {
            if (_selected == index || _votingArguments.task.isEmpty) {
              _selected = -1;
            } else {
              _selected = index;
            }
          })
        },
      ),
      _votingArguments.isHost
          ? EstimatorButton(
              text: 'Finish voting',
              onPressed: () => {
                _navigateToResults(_votingArguments.task, _votingArguments.isHost, _votingArguments.sessionCode)
              },
            )
          : Container(),
      EstimatorButton(
        text: _votingArguments.isHost ? 'Go back' : 'Leave',
        bottomMargin: BOTTOM_MARGIN,
        onPressed: () => {Navigator.pop(context, "left")},
      )
    ]);
  }
}
