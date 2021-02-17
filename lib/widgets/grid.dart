import 'package:estimator/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EstimatorGrid extends StatelessWidget {
  const EstimatorGrid({
    Key key,
    this.values,
    this.selected,
    this.onPressed,
  }) : super(key: key);

  final List<String> values;
  final int selected;
  final Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = values
        .asMap()
        .map(
          (index, value) => MapEntry(
            index,
            ButtonTheme(
              height: 120.0,
              minWidth: 100.0,
              buttonColor: selected != index ? const Color.fromARGB(255, 54, 191, 177) : DARK_GREEN,
              child: RaisedButton(
                onPressed: () => {onPressed(index)},
                child: Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'HemiHead',
                    fontSize: 24.0,
                    color: const Color.fromARGB(255, 4, 53, 64),
                  ),
                ),
              ),
            ),
          ),
        )
        .values
        .toList();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 15.0,
            runSpacing: 15.0,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: buttons,
          ),
        ),
      ),
    );
  }
}
