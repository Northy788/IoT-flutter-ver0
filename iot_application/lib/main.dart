import 'package:flutter/material.dart';
import 'package:iot_application/widget/iot_button.dart';
import 'package:iot_application/widget/reconnect_button.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TcpSocketConnection socketConnection =
      TcpSocketConnection("192.168.4.1", 8080);

  String message = "";
  Color state = Colors.red;
  IconData led = Icons.light_mode_outlined;

  @override
  void initState() {
    super.initState();
    startConnection();
  }

  void messageReceived(String msg) {
    setState(() {
      message = msg;
    });
  }

  void messageTransmitted(String msg) {
    socketConnection.sendMessage(msg);
    //print("connected");
  }

  void startConnection() async {
    socketConnection.enableConsolePrint(true);
    if (await socketConnection.canConnect(3000, attempts: 3)) {
      await socketConnection.connect(1000, messageReceived, attempts: 3);
    }
    setColorState();
    socketConnection.sendMessage("device connected.\n\r");
  }

  Color getState() {
    if (socketConnection.isConnected()) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  void setLED() {
    setState(() {
      if (led == Icons.light_mode_outlined) {
        led = Icons.light_mode;
        socketConnection.sendMessage("ON");
      } else {
        led = Icons.light_mode_outlined;
        socketConnection.sendMessage('OFF');
      }
    });
  }

  void setColorState() {
    setState(() {
      state = getState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          //leading: Icon(Icons.light),
          backgroundColor: Colors.white,
          title: const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "IoT Demo",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Icon(
                Icons.circle,
                size: 16,
                color: state,
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              iotButton(
                ledState: led,
                toggle: setLED,
              ),
              const SizedBox(
                height: 350,
              ),
              reconnectButton(
                connecting: startConnection,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
