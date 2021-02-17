import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class EstimatorServer {
  static final EstimatorServer _singleton = EstimatorServer._internal();
  factory EstimatorServer() {
    return _singleton;
  }
  EstimatorServer._internal();

  final IO.Socket socket = IO.io(
    'http://10.0.2.2:3000',
    OptionBuilder().disableAutoConnect().setTransports(['websocket']).build(),
  );
}