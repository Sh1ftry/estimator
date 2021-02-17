import 'package:estimator/constants.dart';
import 'package:estimator/models/voting_arguments.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/logo.dart';
import 'package:estimator/widgets/text_field.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinSession extends StatefulWidget {
  @override
  _JoinSessionState createState() => _JoinSessionState();
}

class _JoinSessionState extends State<JoinSession> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _sessionCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfiguration();
  }

  _loadConfiguration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayNameController.text = (prefs.getString('displayName') ?? "");
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
        controller: _sessionCodeController,
        hintText: 'Session code',
      ),
      EstimatorButton(
        text: 'Join a session',
        onPressed: () => {
          Navigator.pushNamed(
            context,
            '/vote',
            arguments: VotingArguments("", false, _sessionCodeController.text, 0),
          )
        },
      ),
      EstimatorButton(
        text: 'Go back',
        bottomMargin: BOTTOM_MARGIN,
        onPressed: () => {Navigator.pop(context)},
      )
    ]);
  }
}
