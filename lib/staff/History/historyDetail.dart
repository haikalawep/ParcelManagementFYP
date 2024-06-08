import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parcelmanagement/class/history_Model.dart';
import 'package:parcelmanagement/class/parcel_class.dart';
import 'package:parcelmanagement/common/roundTextfield.dart'; // Import the updated RoundTitleTextfield widget

class HistoryDetail extends StatelessWidget {
  final History history;

  const HistoryDetail({Key? key, required this.history}) : super(key: key);

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
                  hintText: history.nameR,
                  enabled: false,
                  //hintStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RoundTitleTextfield(
                      title: "Code",
                      hintText: history.code,
                      enabled: false,
                      //hintStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: RoundTitleTextfield(
                      title: "Parcel No",
                      hintText: history.parcelNo.toString(),
                      enabled: false,
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
                      hintText: DateFormat('yyyy-MM-dd').format(history.dateManaged),
                      enabled: false,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: RoundTitleTextfield(
                      title: "Collect Option",
                      hintText: history.optCollect,
                      enabled: false,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Color",
                  hintText: history.color,
                  enabled: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Size",
                  hintText: history.size,
                  enabled: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Status",
                  hintText: history.status,
                  enabled: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Phone Number",
                  hintText: history.phoneR,
                  enabled: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RoundTitleTextfield(
                  title: "Charge",
                  hintText: 'RM ${history.charge.toString()}',
                  enabled: false,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
