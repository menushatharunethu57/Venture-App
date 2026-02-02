import 'package:flutter/material.dart';
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
  }

  void navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Profilepg(
          value1: name.text,
          value2: contact.text,
          value3: mail.text,
          value4: about.text,
          value5: '',
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
        name: name,
        contact: contact,
        mail: mail,
        about: about,
        navigate: navigate,
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
    required this.name,
    required this.contact,
    required this.mail,
    required this.about,
    required this.navigate,
  });

  final TextEditingController name;
  final TextEditingController contact;
  final TextEditingController mail;
  final TextEditingController about;
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
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 60,
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.grey[600],
                ),
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
