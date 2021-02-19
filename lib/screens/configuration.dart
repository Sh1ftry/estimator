import 'package:estimator/constants.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/logo.dart';
import 'package:estimator/widgets/text_field.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuration extends StatefulWidget {
  @override
  _ConfigurationState createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _estimatesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadConfiguration();
  }

  _loadConfiguration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayNameController.text = (prefs.getString('displayName') ?? "");
      _estimatesController.text = (prefs.getString('estimates') ?? "");
    });
  }

  _saveConfiguration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('displayName', _displayNameController.text);
    prefs.setString('estimates', _estimatesController.text);
  }

  @override
  Widget build(BuildContext context) {
    return EstimatorLayout(widgets: [
      EstimatorLogo(),
      Form(
        key: _formKey,
        child: Column(
          children: [
            EstimatorTextField(
              hintText: 'Display name',
              controller: _displayNameController,
              validator: (value) {
                String trimmedValue = value.trim();
                RegExp regex = RegExp(r'^[a-zA-Z0-9\s]+$');
                if (trimmedValue.length > 0) {
                  if(!regex.hasMatch(trimmedValue)) {
                    return 'Only numbers and letters are allowed';
                  }
                  if(trimmedValue.length > 32 || trimmedValue.length < 3) {
                    return 'Display name should be between 3 and 32 characters';
                  }
                }
                return null;
              },
            ),
            EstimatorTextField(
              hintText: 'Space separated estimates',
              controller: _estimatesController,
              validator: (value) {
                String trimmedValue = value.trim();
                RegExp regex = RegExp(r'^([a-zA-Z0-9]+\s?)+$');
                if (trimmedValue.length > 0 && !regex.hasMatch(trimmedValue)) {
                  return 'Only numbers and letters are allowed';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      EstimatorButton(
        text: 'Save',
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _saveConfiguration();
            Navigator.pop(context);
          }
        },
      ),
      EstimatorButton(
        text: 'Go back',
        bottomMargin: BOTTOM_MARGIN,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ]);
  }
}
