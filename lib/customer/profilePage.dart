import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage; // Import firebase_storage with a prefix
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parcelmanagement/customer/SplashUpdate.dart';
import 'package:parcelmanagement/view/loginPage.dart';
import 'package:flutter/material.dart';
import '../common/color_extension.dart';
import '../common/roundTextfield.dart';
import '../common/round_Button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileView extends StatefulWidget {
  final User user;

  const ProfileView({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? imageUrl;
  File? _image;

  final TextEditingController _nameUserController = TextEditingController();
  final TextEditingController _emailUserController = TextEditingController();
  final TextEditingController _mobileUserController = TextEditingController();
  final TextEditingController _collegeUserController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.user.email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData =
        userSnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _nameUserController.text = userData['name'] ?? '';
          _emailUserController.text = userData['email'] ?? '';
          _mobileUserController.text = userData['mobile'] ?? '';
          _collegeUserController.text = userData['college'] ?? '';
          imageUrl = userData['imageUrl'] ?? '';
        });
      } else {
        print('User document not found for email: ${widget.user.email}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }


  Future<void> _pickImage() async {
    print('Profile picture tapped');
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadImageToFirebase();
      } else {
        print('No image selected.');
      }
    });
  }
  Future<void> uploadImageToFirebase() async {
    if (_image != null) {
      try {
        // Upload image to Firebase Storage
        final firebase_storage.Reference firebaseStorageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('userProfileImages/${widget.user.email}/profilePic.jpg');

        await firebaseStorageRef.putFile(_image!);

        // Get the URL of the uploaded image
        final String downloadURL = await firebaseStorageRef.getDownloadURL();

        // Save the image URL in the Firestore user document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.email)
            .update({'imageUrl': downloadURL});

        setState(() {
          imageUrl = downloadURL;
        });
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to upload image. Please try again.')));
      }
    }
  }

  void updateProfile() {
    String newNameUser = _nameUserController.text;
    String newEmailUser = _emailUserController.text;
    String newMobileUser = _mobileUserController.text;
    String newCollegeUser = _collegeUserController.text;

    Map<String, dynamic> updatedData = {
      'name': newNameUser,
      'email': newEmailUser,
      'mobile': newMobileUser,
      'college': newCollegeUser,
    };

    CollectionReference usersRef =
    FirebaseFirestore.instance.collection('users');

    usersRef
        .where('email', isEqualTo: widget.user.email)
        .limit(1)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        DocumentReference userRef = usersRef.doc(docId);

        userRef.update(updatedData).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile update failed')),
          );
        });
      } else {
        print('Profile not found in Firestore');
      }
    }).catchError((error) {
      print('Error querying Firestore: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final screenSize = MediaQuery.of(context).size;
    double iconSize = screenSize.width * 0.08;
    double radius = screenSize.width * 0.17;

    return SafeArea(
        child: Scaffold(
          backgroundColor: TColor.secondary,
          appBar: AppBar(
            title: const Text("My Account", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            actions: [
              IconButton(
                  icon: const Icon(Icons.logout),
                  color: Colors.white,
                  onPressed: () {
                    signUserOut(context);
                  }
              ),
            ],
            backgroundColor: TColor.primary,
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*SizedBox(height: screenHeight * 0.01),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: screenWidth*0.14,
                      ),
                      Text(
                        'Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: screenHeight * 0.035,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        onPressed: () {
                          signUserOut(context);
                        },
                        icon: Icon(
                          Icons.exit_to_app,
                          size: iconSize,
                        ),
                      ),
                    ],
                  ),
                ),*/
                SizedBox(height: screenHeight * 0.02),
                Stack(
                  children: [
                    // Container(
                    //   width: double.infinity,
                    //   height: 150,
                    //   decoration: BoxDecoration(
                    //     color: Colors.green,
                    //     borderRadius: BorderRadius.circular(20),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () async { _pickImage(); },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black, // Adjust border color here
                            width: 4.0, // Adjust border width here
                          ),
                        ),
                        child: CircleAvatar(
                          radius: radius,
                          backgroundColor: TColor.placeholder,
                          backgroundImage: imageUrl != null
                              ? NetworkImage(imageUrl!)
                              : null,
                          child: imageUrl == null
                              ? Icon(
                            Icons.person,
                            size: iconSize,
                            color: TColor.secondaryText,
                          )
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right:6,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.amber),
                        child: const Icon(
                          CupertinoIcons.pencil,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Hi there, ${_nameUserController.text}!',
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildInputField(context, 'Name', _nameUserController.text, Icon(Icons.person), controller: _nameUserController),
                SizedBox(height: screenHeight * 0.02),
                _buildInputField(context, 'Email', _emailUserController.text, Icon(Icons.email),controller: _emailUserController),
                SizedBox(height: screenHeight * 0.02),
                _buildInputField(context, 'Phone', _mobileUserController.text, Icon(Icons.phone), controller: _mobileUserController),
                SizedBox(height: screenHeight * 0.02),
                _buildInputField(context, 'College', _collegeUserController.text, Icon(Icons.my_location), controller: _collegeUserController),
                SizedBox(height: screenHeight * 0.02),

                //itemProfile('Name', _nameUserController, Icon(Icons.person)),
                //const SizedBox(height: 10),
                // itemProfile('Email', _emailUserController, CupertinoIcons.mail),
                // const SizedBox(height: 10),
                // itemProfile('Phone', _mobileUserController, CupertinoIcons.phone),
                // const SizedBox(height: 10),
                // itemProfile('College', _collegeUserController, CupertinoIcons.location),
                // const SizedBox(height: 20),
                // Padding(
                //   padding:
                //   const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                //   child: RoundTitleTextfield(
                //     title: "Name",
                //     hintText: "Enter Name",
                //     controller: _nameUserController,
                //   ),
                // ),
                // Padding(
                //   padding:
                //   const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                //   child: RoundTitleTextfield(
                //     title: "Email",
                //     hintText: "Enter Email",
                //     keyboardType: TextInputType.emailAddress,
                //     controller: _emailUserController,
                //   ),
                // ),
                // Padding(
                //   padding:
                //   const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                //   child: RoundTitleTextfield(
                //     title: "Mobile No",
                //     hintText: "Enter Mobile No",
                //     controller: _mobileUserController,
                //     keyboardType: TextInputType.phone,
                //   ),
                // ),
                // Padding(
                //   padding:
                //   const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                //   child: RoundTitleTextfield(
                //     title: "College",
                //     hintText: "Enter College",
                //     controller: _collegeUserController,
                //   ),
                // ),
                SizedBox(height: screenHeight * 0.01),
                GestureDetector(
                  onTap: () {
                    _showSaveConfirmationDialog();
                  },
                  child: Container(width: screenWidth*0.5, height: screenHeight*0.07, alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), color: TColor.moreButton), child: Text(
                    "Save",
                    style: TextStyle(
                        fontSize: screenHeight * 0.03, color: TColor.white, fontWeight: FontWeight.w500),
                  ),),
                ),

                // Padding(
                //   padding:
                //   const EdgeInsets.symmetric(horizontal: 20),
                //   child: RoundButton(
                //     title: "Save",
                //     //onPressed: updateProfile,
                //     onPressed: () {
                //       _showSaveConfirmationDialog();
                //     },
                //   ),
                // ),
                SizedBox(height: screenHeight * 0.01),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildInputField(
      BuildContext context,
      String labelText,
      String initialValue,
      Icon icon,
      {required TextEditingController controller}
      ) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04), // Adjust horizontal padding as needed
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 16.0),
        ),
        child: TextField(
          style: TextStyle(fontSize: screenHeight * 0.025),
          controller: controller,
          decoration: InputDecoration(
            hintText: initialValue,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }


  void _showSaveConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Changes'),
          content: const Text('Are you sure you want to save the changes?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                updateProfile();
                // Navigate to SplashView
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SplashUpdateView(user: widget.user)),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
  //
  // void updateField(
  //     String field, String updatedValue, TextEditingController controller) {
  //   Map<String, dynamic> updatedData = {field.toLowerCase(): updatedValue};
  //
  //   CollectionReference usersRef =
  //   FirebaseFirestore.instance.collection('users');
  //
  //   usersRef
  //       .where('email', isEqualTo: widget.user.email)
  //       .limit(1)
  //       .get()
  //       .then((querySnapshot) {
  //     if (querySnapshot.docs.isNotEmpty) {
  //       String docId = querySnapshot.docs.first.id;
  //       DocumentReference userRef = usersRef.doc(docId);
  //
  //       userRef.update(updatedData).then((value) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('$field updated successfully')),
  //         );
  //         setState(() {
  //           controller.text = updatedValue;
  //         });
  //       }).catchError((error) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('$field update failed')),
  //         );
  //       });
  //     } else {
  //       print('Profile not found in Firestore');
  //     }
  //   }).catchError((error) {
  //     print('Error querying Firestore: $error');
  //   });
  // }

}
