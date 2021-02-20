import 'package:estimator/constants.dart';
import 'package:estimator/services/estimation_service.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/logo.dart';
import 'package:estimator/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class JoinSession extends StatefulWidget {
  @override
  _JoinSessionState createState() => _JoinSessionState();
}

class _JoinSessionState extends State<JoinSession> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _sessionCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  EstimationService _server = EstimationService();

  @override
  void initState() {
    super.initState();
    _loadConfiguration();
  }

  void _loadConfiguration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayNameController.text = (prefs.getString('displayName') ?? "");
    });
  }

  void _navigateToVoting() {
    Navigator.pushNamed(context, '/vote/user');
  }

  void _joinSessionClicked() {
    if(_formKey.currentState.validate()) {
      _server.connect();
      _server
          .joinSession(_sessionCodeController.text, Uuid().v4(),
          _displayNameController.text)
          .then((v) => {_navigateToVoting()}, onError: (_) {
        _showError();
      });
    }
  }

  void _showError() {
    _server.disconnect();
    Get.snackbar('Joining session failed',
        'Please check Internet connection and session code',
        borderRadius: 0, colorText: RED);
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
              controller: _displayNameController,
              hintText: 'Display name',
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
              controller: _sessionCodeController,
              hintText: 'Session code',
              validator: (value) {
                String trimmedValue = value.trim();
                RegExp regex = RegExp(r'^[a-zA-Z0-9]{9}$');
                if(!regex.hasMatch(trimmedValue)) {
                  return 'Session code should consist of 9 letters and numbers';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      EstimatorButton(
        text: 'Join a session',
        onPressed: _joinSessionClicked,
      ),
      EstimatorButton(
        text: 'Go back',
        bottomMargin: BOTTOM_MARGIN,
        onPressed: () => {Navigator.pop(context)},
      )
    ]);
  }
}
