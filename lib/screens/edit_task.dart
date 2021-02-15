import 'package:estimator/constants.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditTask extends StatelessWidget {
  EditTask({Key key, this.task}) : super(key: key);

  final String task;
  final UnderlineInputBorder _noBorder = UnderlineInputBorder(
    borderSide: BorderSide(
      width: 0.0,
      color: Colors.transparent,
    ),
  );

  @override
  Widget build(BuildContext context) {
    TextEditingController editingController = TextEditingController();
    if(task != "") {
      editingController.text = task;
    }
    return EstimatorLayout(
      widgets: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: editingController,
              maxLines: 100,
              keyboardType: TextInputType.multiline,
              style: TextStyle(
                fontFamily: 'HemiHead',
                fontSize: 24.0,
                color: VERY_DARK_GREEN,
              ),
              decoration: InputDecoration(
                labelText: 'Task description',
                labelStyle: TextStyle(color: LIGHT_GRAY),
                enabledBorder: _noBorder,
                border: _noBorder,
                focusedBorder: _noBorder,
              ),
              cursorColor: VERY_DARK_GREEN,
            ),
          ),
        ),
        EstimatorButton(
          text: 'Save',
          onPressed: () => {Navigator.pop(context, editingController.text)},
        ),
        EstimatorButton(
          text: 'Go back',
          bottomMargin: 60,
          onPressed: () => {Navigator.pop(context, '')},
        )
      ],
    );
  }
}
