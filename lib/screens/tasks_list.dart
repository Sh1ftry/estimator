import 'package:estimator/constants.dart';
import 'package:estimator/screens/edit_task.dart';
import 'package:estimator/services/estimation_service.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/double_button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/tasks_list.dart';
import 'package:estimator/widgets/two_color_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final ScrollController _scrollController = ScrollController();
  int _selectedTask = -1;
  String _sessionCode = '';

  EstimationService _server = EstimationService();
  final List<String> _tasks = [];

  @override
  void initState() {
    super.initState();
    _server.sessionCode.take(1).listen((sessionCode) {
      setState(() {
        _sessionCode = sessionCode;
      });
    });
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
    _server.changeTask(_tasks[_selectedTask]);
    final results = await Navigator.pushNamed(
      context,
      '/vote/host'
    );
    if(results == null) {
      setState(() {
        _tasks.removeAt(_selectedTask);
        _selectedTask = -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            _server.disconnect();
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
