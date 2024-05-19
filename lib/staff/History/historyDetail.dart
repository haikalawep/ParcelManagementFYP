import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parcelmanagement/class/parcel_class.dart';
import 'package:parcelmanagement/common/roundTextfield.dart'; // Import the updated RoundTitleTextfield widget

class HistoryDetail extends StatelessWidget {
  final Parcel parcel;

  const HistoryDetail({Key? key, required this.parcel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcel Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Parcel Name",
                  hintText: parcel.nameR,
                  //hintStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RoundTitleTextfield(
                      title: "Code",
                      hintText: parcel.code,
                      //hintStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: RoundTitleTextfield(
                      title: "Parcel No",
                      hintText: parcel.parcelNo.toString(),
                      //hintStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10, // Adjust the height value to set the desired gap
              ),
              Row(
                children: [
                  Expanded(
                    child: RoundTitleTextfield(
                      title: "Date Managed",
                      hintText: DateFormat('yyyy-MM-dd').format(parcel.dateManaged),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: RoundTitleTextfield(
                      title: "Collect Option",
                      hintText: parcel.optCollect,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Color",
                  hintText: parcel.color,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Size",
                  hintText: parcel.size,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Status",
                  hintText: parcel.status,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Phone Number",
                  hintText: parcel.phoneR,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Charge",
                  hintText: parcel.charge.toString(),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
