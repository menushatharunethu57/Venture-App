import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';

class Editpg extends StatefulWidget {
  const Editpg({
    super.key,
    required this.value1,
    required this.value2,
    required this.value3,
    required this.value4,
    required this.value5,
  });

  final String value1;
  final String value2;
  final String value3;
  final String value4;
  final String value5;

  @override
  State<Editpg> createState() => _EditpgState();
}

class _EditpgState extends State<Editpg> {
  File? image;
  String imagePath = "";
  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController about = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = widget.value1;
    contact.text = widget.value2;
    mail.text = widget.value3;
    about.text = widget.value4;
    imagePath = widget.value5;

    if (imagePath.isNotEmpty) {
      image = File(imagePath);
    }
  }

  Future pickProfileImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      setState(() {
        image = File(picked.path);
        imagePath = picked.path;
      });
    }
  }

  void removeImage() {
    setState(() {
      image = null;
      imagePath = "";
    });
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name.text);
    await prefs.setString('contact', contact.text);
    await prefs.setString('email', mail.text);
    await prefs.setString('about', about.text);
    await prefs.setString('imagePath', imagePath);
  }

  void navigate() async {
    await saveData();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Profilepg(
          value1: name.text,
          value2: contact.text,
          value3: mail.text,
          value4: about.text,
          value5: imagePath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D5F5D),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.home, color: Colors.white),
          ),
        ],
      ),
      body: Body(
        image: image,
        name: name,
        contact: contact,
        mail: mail,
        about: about,
        pickProfileImage: pickProfileImage,
        removeImage: removeImage,
        navigate: navigate,
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
    required this.image,
    required this.name,
    required this.contact,
    required this.mail,
    required this.about,
    required this.pickProfileImage,
    required this.removeImage,
    required this.navigate,
  });

  final File? image;
  final TextEditingController name;
  final TextEditingController contact;
  final TextEditingController mail;
  final TextEditingController about;
  final Future<void> Function(ImageSource source) pickProfileImage;
  final VoidCallback removeImage;
  final VoidCallback navigate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 60,
                    backgroundImage: image != null ? FileImage(image!) : null,
                    child: image == null
                        ? ClipOval(
                            child: Image.network(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Circle-icons-profile.svg/3840px-Circle-icons-profile.svg.png",
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        pickProfileImage(ImageSource.camera);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                          "Take Photo",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        pickProfileImage(ImageSource.gallery);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                          "Choose from Gallery",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    if (image != null) Divider(),
                                    if (image != null)
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          removeImage();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          child: Text(
                                            "Remove Photo",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF2D5F5D),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            TextField(
              controller: name,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: contact,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone),
                labelText: "Contact No",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: mail,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: about,
              maxLines: 4,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.info),
                labelText: "About",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: navigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2D5F5D),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}