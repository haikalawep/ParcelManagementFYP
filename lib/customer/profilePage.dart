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
    return SafeArea(
        child: Scaffold(
          backgroundColor: TColor.background,

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        'Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        onPressed: () {
                          signUserOut(context);
                        },
                        icon: const Icon(
                          Icons.exit_to_app,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: TColor.placeholder,
                        backgroundImage: imageUrl != null
                            ? NetworkImage(imageUrl!)
                            : null,
                        child: imageUrl == null
                            ? Icon(
                          Icons.person,
                          size: 65,
                          color: TColor.secondaryText,
                        )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: TColor.white),
                        child: const Icon(
                          CupertinoIcons.pencil,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Hi there, ${_nameUserController.text}!',
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),

                _buildInputField(context, 'Name', _nameUserController.text, Icon(Icons.person), controller: _nameUserController),
                const SizedBox(height: 10),
                _buildInputField(context, 'Email', _emailUserController.text, Icon(Icons.email),controller: _emailUserController),
                const SizedBox(height: 10),
                _buildInputField(context, 'Phone', _mobileUserController.text, Icon(Icons.phone), controller: _mobileUserController),
                const SizedBox(height: 10),
                _buildInputField(context, 'College', _collegeUserController.text, Icon(Icons.my_location), controller: _collegeUserController),
                const SizedBox(height: 10),


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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showSaveConfirmationDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: TColor.button, // Set the text color here
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12), // Adjust padding if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Adjust border radius if needed
                    ),
                  ),
                  child: Text('Save'),
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildInputField(
      BuildContext context, String labelText, String initialValue, Icon icon, {required TextEditingController controller}) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: TColor.topBar,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: initialValue,
          border: InputBorder.none,
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
