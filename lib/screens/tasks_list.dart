import 'package:estimator/screens/edit_task.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/double_button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/tasks_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final ScrollController _scrollController = ScrollController();
  int _selectedTask = -1;

  final List<String> tasks = List.generate(
      1, (i) => 'ID-177 Lorem ipsum dolor sit amet lorem dolor elele');

  _navigateToTaskEdit(BuildContext context, int index) async {
    final task = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTask(task: index != -1 ? tasks[index] : null),
      ),
    );
    final taskTrimmed = task.toString().trim();
    if(index != -1 && taskTrimmed != "") {
      setState(() {
        tasks[index] = taskTrimmed;
      });
    }
    else if(taskTrimmed != "") {
      setState(() {
        tasks.add(taskTrimmed);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return EstimatorLayout(
      widgets: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: Text(
              "Select a task to estimate",
              style: TextStyle(
                  fontFamily: 'HemiHead',
                  fontSize: 24.0,
                  color: const Color.fromARGB(255, 4, 53, 64)),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: EstimatorTasksList(
              scrollController: _scrollController,
              tasks: tasks,
              selectedTask: _selectedTask,
              onDeletePressed: (index) {
                setState(() {
                  if (_selectedTask == index) {
                    _selectedTask = -1;
                  }
                  tasks.removeAt(index);
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
            onPressed: () => {Navigator.pushNamed(context, '/vote')}),
        EstimatorButton(
          text: 'Go back',
          bottomMargin: 60,
          onPressed: () => {Navigator.pop(context)},
        )
      ],
    );
  }
}
