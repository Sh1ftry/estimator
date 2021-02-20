import 'package:estimator/constants.dart';
import 'package:estimator/services/estimation_service.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/logo.dart';
import 'package:estimator/widgets/text_field.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class StartSession extends StatefulWidget {
  @override
  _StartSessionState createState() => _StartSessionState();
}

class _StartSessionState extends State<StartSession> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _estimatesController = TextEditingController();
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
      _estimatesController.text = (prefs.getString('estimates') ?? "");
    });
  }

  void _navigateToTaskList() {
    Navigator.pushNamed(context, '/tasks');
  }

  void _startSessionClicked() {
    if(_formKey.currentState.validate()) {
      _server.connect();
      _server
          .startSession(
          Uuid().v4(), _displayNameController.text, _estimatesController.text)
          .then((v) => {_navigateToTaskList()}, onError: (_) {
        _showError();
      });
    }
  }

  void _showError() {
    _server.disconnect();
    Get.snackbar(
        'Starting session failed', 'Please check Internet connection',
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
              controller: _estimatesController,
              hintText: 'Space separated estimates',
              validator: (value) {
                String trimmedValue = value.trim();
                RegExp regex = RegExp(r'^([a-zA-Z0-9\.]+\s?)+$');
                if (!regex.hasMatch(trimmedValue)) {
                  return 'Only numbers and letters are allowed';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      EstimatorButton(
        text: 'Start a new session',
        onPressed: _startSessionClicked,
      ),
      EstimatorButton(
        text: 'Go back',
        bottomMargin: BOTTOM_MARGIN,
        onPressed: () => {Navigator.pop(context)},
      )
    ]);
  }
}
