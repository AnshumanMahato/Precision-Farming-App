import 'package:socket_io_client/socket_io_client.dart' as IO;

class PumpService {
  late IO.Socket _socket;
  Function? startPump;
  Function? stopPump;

  // Initialize the connection
  void initializeConnection(String farmId) {
    _socket = IO.io(
      'http://192.168.1.35:5000', // Replace with your server address
      IO.OptionBuilder()
          .setTransports(['websocket']) // Specify transport
          .enableAutoConnect() // Automatically connect
          .setReconnectionAttempts(3) // Retry connection
          .build(),
    );

    // Listen for connection
    _socket.onConnect((_) {
      print('Connected to server');
      _socket.emit('joinFarm', farmId);
    });

    // Handle disconnection
    _socket.onDisconnect((_) {
      print('Disconnected from server');
    });

    // Listen for custom events
    _socket.on('startPump', (data) {
      print('Pump started');
      if (startPump != null) {
        startPump!();
      }
    });

    _socket.on('stopPump', (data) {
      print('Pump stopped');
      if (stopPump != null) {
        stopPump!();
      }
    });
  }

  // Emit events to the server
  void sendData(String event, Map<String, dynamic> data) {
    _socket.emit(event, data);
  }

  // Disconnect from the server
  void disconnect() {
    _socket.disconnect();
  }
}
