import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EstimatorGrid extends StatelessWidget {
  const EstimatorGrid({
    Key key,
    this.values,
  }) : super(key: key);

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = values
        .map((value) => ButtonTheme(
              height: 120.0,
              minWidth: 100.0,
              buttonColor: const Color.fromARGB(255, 54, 191, 177),
              child: RaisedButton(
                onPressed: () => {},
                child: Text(
                  value,
                  style: TextStyle(
                      fontFamily: 'HemiHead',
                      fontSize: 24.0,
                      color: const Color.fromARGB(255, 4, 53, 64)),
                ),
              ),
            ))
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
