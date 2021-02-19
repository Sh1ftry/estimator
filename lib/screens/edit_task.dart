import 'package:estimator/constants.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditTask extends StatelessWidget {
  EditTask({Key key, this.task}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: editingController,
                maxLines: 100,
                keyboardType: TextInputType.multiline,
                validator: (data) {
                  if(data.length < 3 || data.length > 128) {
                    return "Task should consist of 3 to 128 characters";
                  }
                  return null;
                },
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
        ),
        EstimatorButton(
          text: 'Save',
          onPressed: () {
            if(_formKey.currentState.validate()) {
              Navigator.pop(context, editingController.text);
            }
          },
        ),
        EstimatorButton(
          text: 'Go back',
          bottomMargin: BOTTOM_MARGIN,
          onPressed: () => {Navigator.pop(context, '')},
        )
      ],
    );
  }
}
