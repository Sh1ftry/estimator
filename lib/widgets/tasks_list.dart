import 'package:estimator/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EstimatorTasksList extends StatelessWidget {
  EstimatorTasksList({
    Key key,
    this.scrollController,
    this.tasks,
    this.selectedTask,
    this.onDeletePressed,
    this.onTaskPressed,
  }) : super(key: key);

  final ScrollController scrollController;
  final List<String> tasks;
  final int selectedTask;
  final Function(int) onDeletePressed;
  final Function onTaskPressed;

  bool isSelected(int taskNumber) {
    return taskNumber == selectedTask;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: true,
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ListView.builder(
            controller: scrollController,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Container(
                color: isSelected(index) ? GREEN_GRAY : Colors.transparent,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete_outline),
                      iconSize: 30.0,
                      color: LIGHT_GRAY,
                      onPressed: () => {onDeletePressed(index)},
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () => {onTaskPressed(index)},
                        child: Text(
                          tasks[index],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'HemiHead',
                            fontSize: 24.0,
                            color: DARK_GREEN,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}