import 'package:estimator/constants.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/logo.dart';
import 'package:estimator/widgets/text_field.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartSession extends StatefulWidget {
  @override
  _StartSessionState createState() => _StartSessionState();
}

class _StartSessionState extends State<StartSession> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _estimatesController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return EstimatorLayout(widgets: [
      EstimatorLogo(),
      EstimatorTextField(
        controller: _displayNameController,
        hintText: 'Display name',
      ),
      EstimatorTextField(
        controller: _estimatesController,
        hintText: 'Space separated estimates',
      ),
      EstimatorButton(
        text: 'Start a new session',
        onPressed: () => {Navigator.pushNamed(context, '/tasks')},
      ),
      EstimatorButton(
        text: 'Go back',
        bottomMargin: BOTTOM_MARGIN,
        onPressed: () => {Navigator.pop(context)},
      )
    ]);
  }
}
