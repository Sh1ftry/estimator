import 'package:estimator/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EstimatorTextField extends StatelessWidget {
  const EstimatorTextField({
    Key key,
    this.hintText,
    this.validator,
    this.controller,
  }) : super(key: key);

  final String hintText;
  final Function(String) validator;
  final TextEditingController controller;

  UnderlineInputBorder _getBorder(Color color) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        width: 4.0,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Material(
        color: const Color.fromARGB(255, 54, 191, 177),
        elevation: 3,
        child: Container(
          height: 80.0,
          child: TextFormField(
            controller: controller,
            validator: validator,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'HemiHead',
              fontSize: 24.0,
              color: VERY_DARK_GREEN,
            ),
            cursorColor: VERY_DARK_GREEN,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              errorStyle: TextStyle(
                color: RED,
                fontFamily: 'HemiHead',
              ),
              enabledBorder: _getBorder(LIGHT_GRAY),
              border: _getBorder(LIGHT_GRAY),
              focusedBorder: _getBorder(LIGHT_GRAY),
              errorBorder: _getBorder(RED),
              focusedErrorBorder: _getBorder(RED),
              labelText: hintText,
              //hintText: hintText,
              labelStyle: TextStyle(color: LIGHT_GRAY, fontSize: 20.0),
            ),
          ),
        ),
      ),
    );
  }
}
