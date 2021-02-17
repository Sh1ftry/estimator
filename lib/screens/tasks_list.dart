import 'package:estimator/constants.dart';
import 'package:estimator/models/voting_arguments.dart';
import 'package:estimator/screens/edit_task.dart';
import 'package:estimator/services/socket.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/double_button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/tasks_list.dart';
import 'package:estimator/widgets/two_color_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final ScrollController _scrollController = ScrollController();
  int _selectedTask = -1;
  String _sessionCode = '';
  int _voters = 0;

  final IO.Socket _socket = EstimatorServer().socket;

  final List<String> _tasks = [];

  @override
  void initState() {
    super.initState();
    _socket.on('joined', _changeMaxUsers);
    _socket.on('user left', _changeMaxUsers);
  }

  @override
  void dispose() {
    _socket.off('joined', _changeMaxUsers);
    _socket.off('user left', _changeMaxUsers);
    super.dispose();
  }

  _navigateToTaskEdit(BuildContext context, int index) async {
    final task = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditTask(task: index != -1 ? _tasks[index] : null),
      ),
    );
    final taskTrimmed = task.toString().trim();
    if (index != -1 && taskTrimmed != "") {
      setState(() {
        _tasks[index] = taskTrimmed;
      });
    } else if (taskTrimmed != "") {
      setState(() {
        _tasks.add(taskTrimmed);
      });
    }
  }

  _navigateToVoting(BuildContext context) async {
    _socket.emit('change', [_tasks[_selectedTask]]);
    final results = await Navigator.pushNamed(
      context,
      '/vote',
      arguments: VotingArguments(_tasks[_selectedTask], true, _sessionCode, _voters),
    );
    if(results == null) {
      setState(() {
        _tasks.removeAt(_selectedTask);
        _selectedTask = -1;
      });
    }
  }

  _changeMaxUsers(usersCount) {
    setState(() {
      _voters = usersCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    _sessionCode = ModalRoute.of(context).settings.arguments;
    return EstimatorLayout(
      widgets: [
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
          child: Center(
            child: Text(
              "Select a task to estimate",
              style: TextStyle(
                fontFamily: 'HemiHead',
                fontSize: 24.0,
                color: DARK_GREEN,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: EstimatorTasksList(
              scrollController: _scrollController,
              tasks: _tasks,
              selectedTask: _selectedTask,
              onDeletePressed: (index) {
                setState(() {
                  if (_selectedTask == index) {
                    _selectedTask = -1;
                  }
                  _tasks.removeAt(index);
                });
              },
              onTaskPressed: (index) {
                setState(() {
                  _selectedTask = index;
                });
              },
            ),
          ),
        ),
        EstimatorDoubleButton(
          leftText: 'Add a new task',
          leftOnPressed: () => {_navigateToTaskEdit(context, -1)},
          rightText: 'Edit task',
          rightOnPressed: _selectedTask != -1
              ? () => {_navigateToTaskEdit(context, _selectedTask)}
              : null,
        ),
        EstimatorButton(
          text: 'Start voting',
          onPressed:
              _selectedTask != -1 ? () => {_navigateToVoting(context)} : null,
        ),
        EstimatorButton(
          text: 'End session',
          bottomMargin: BOTTOM_MARGIN,
          onPressed: () {
            _socket.disconnect();
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
