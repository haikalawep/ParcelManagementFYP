import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage; // Import firebase_storage with a prefix
import 'package:image_picker/image_picker.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF9E5DE),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 46),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        signUserOut(context);
                      },
                      icon: Icon(Icons.exit_to_app),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async { _pickImage();/*
                  await showModalBottomSheet(
                    context: context,
                    builder: (context) => BottomSheet(
                      onClosing: () {},
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('Take a photo'),
                            onTap: () async {
                              Navigator.pop(context);
                              await _pickImage(ImageSource.camera); // Use _pickImage instead of pickImage
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text('Choose from gallery'),
                            onTap: () async {
                              Navigator.pop(context);
                              await _pickImage(ImageSource.gallery); // Use _pickImage instead of pickImage
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                */},
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: TColor.placeholder,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: imageUrl != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      imageUrl!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Icon(
                    Icons.person,
                    size: 65,
                    color: TColor.secondaryText,
                  ),
                ),
              ),
              Text(
                'Hi there, ${_nameUserController.text}!',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: RoundTitleTextfield(
                  title: "Name",
                  hintText: "Enter Name",
                  controller: _nameUserController,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: RoundTitleTextfield(
                  title: "Email",
                  hintText: "Enter Email",
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailUserController,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: RoundTitleTextfield(
                  title: "Mobile No",
                  hintText: "Enter Mobile No",
                  controller: _mobileUserController,
                  keyboardType: TextInputType.phone,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: RoundTitleTextfield(
                  title: "College",
                  hintText: "Enter College",
                  controller: _collegeUserController,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20),
                child: RoundButton(
                  title: "Save",
                  onPressed: updateProfile,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
