import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parcelmanagement/common/color_extension.dart';

class ServoControlApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ServoControlScreen(),
    );
  }
}

class ServoControlScreen extends StatefulWidget {
  @override
  _ServoControlScreenState createState() => _ServoControlScreenState();
}

class _ServoControlScreenState extends State<ServoControlScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _setServoAngle(int angle) async {
    final response = await http.get(Uri.parse('http://192.168.0.22:8000/?angle=$angle'));
    if (response.statusCode == 200) {
      print('Servo angle set to $angle');
    } else {
      print('Failed to set servo angle');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        title: Text('Servo Control'),
        backgroundColor: TColor.topBar,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _setServoAngle(1000);  // Set servo angle to 90 degrees
              },
              child: Text('Open'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _setServoAngle(2000);  // Set servo angle to 0 degrees
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}