import 'package:estimator/constants.dart';
import 'package:estimator/services/socket.dart';
import 'package:estimator/widgets/button.dart';
import 'package:estimator/widgets/layout.dart';
import 'package:estimator/widgets/logo.dart';
import 'package:estimator/widgets/text_field.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';

class StartSession extends StatefulWidget {
  @override
  _StartSessionState createState() => _StartSessionState();
}

class _StartSessionState extends State<StartSession> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _estimatesController = TextEditingController();

  IO.Socket _socket = EstimatorServer().socket;

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

  _navigateToTaskList(room_id) {
    Navigator.pushNamed(context, '/tasks', arguments: room_id);
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
        onPressed: () {
          _socket.connect();
          _socket.emitWithAck(
            'start',
            [Uuid().v4(), _displayNameController.text],
            ack: (data) => _navigateToTaskList(data["room_id"]),
          );
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
