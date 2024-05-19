import 'package:flutter/material.dart';
import 'package:parcelmanagement/staff/home_tab.dart';
import 'package:parcelmanagement/staff/Manage/manage_detailParcel.dart';

class ManageView extends StatefulWidget {
  const ManageView({Key? key}) : super(key: key);

  @override
  State<ManageView> createState() => _ManageViewState();
}


class _ManageViewState extends State<ManageView> {
  void _navigateToManageRecipients() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManageR()),
    );
  }

  void _navigateToSearchHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchH()),
    );
  }

  void _navigateToManageParcel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManageParcelPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // Navigate back to the home tab when the back button is pressed
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainTabView()),
      );
      return false;
    },
      child: Scaffold(
      appBar: AppBar(
        title: Text('Manage'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Manage Recipients'),
            subtitle: Text('ADD/REMOVE/MODIFY RECIPIENTS INFORMATION'),
            onTap: _navigateToManageRecipients,
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search History'),
            subtitle: Text('VIEW HISTORY OF PARCEL PICKUPS'),
            onTap: _navigateToSearchHistory,
          ),
          ListTile(
            leading: Icon(Icons.post_add),
            title: Text('Manage Parcel'),
            subtitle: Text('ADD/REMOVE/MODIFY PARCEL INFORMATION'),
            onTap: _navigateToManageParcel,
          ),
        ],
      ),
    ),
    );
  }
}

class ManageR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Text('Manage R Page'),
      ),
    );
  }
}

class SearchH extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Text('Seach H Page'),
      ),
    );
  }
}

class ManageP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Text('Manage P Page'),
      ),
    );
  }
}