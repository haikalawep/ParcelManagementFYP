import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parcelmanagement/common/color_extension.dart';


class ServoControlScreen extends StatefulWidget {
  const ServoControlScreen({Key? key}) : super(key: key);

  @override
  State<ServoControlScreen> createState() => _ServoControlScreenState();

}

class _ServoControlScreenState extends State<ServoControlScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _setServoAngle(int angle) async {
    final response = await http.get(Uri.parse('http://192.168.0.4:8000/?angle=$angle'));
    if (response.statusCode == 200) {
      print('Servo angle set to $angle');
    } else {
      print('Failed to set servo angle');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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

            GestureDetector(
              onTap: () {
                print("hello");
                _setServoAngle(1000);
              },
              child: Container(
                width: screenWidth*0.63,
                height: screenHeight*0.07,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: TColor.button),
                child: Text(
                  "Open",
                  style: TextStyle(
                      fontSize: screenHeight * 0.03, color: TColor.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            GestureDetector(
              onTap: () {
                _setServoAngle(2000);
              },
              child: Container(
                width: screenWidth*0.63,
                height: screenHeight*0.07,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: TColor.moreButton
                ),
                child: Text(
                  "Close",
                  style: TextStyle(
                      fontSize: screenHeight * 0.03,
                      color: TColor.white,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),

            /*ElevatedButton(
              onPressed: () {
                _setServoAngle(1000);  // Set servo angle to 90 degrees
              },
              child: Text('Open'),
            ),
            SizedBox(height: screenHeight*0.04),
            ElevatedButton(
              onPressed: () {
                _setServoAngle(2000);  // Set servo angle to 0 degrees
              },
              child: Text('Close'),
            ),*/
          ],
        ),
      ),
    );
  }
}