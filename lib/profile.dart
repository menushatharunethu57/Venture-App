import 'package:flutter/material.dart';
import 'edit_profile.dart';

class Profilepg extends StatefulWidget {
  const Profilepg({
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
  State<Profilepg> createState() => _ProfilepgState();
}

class _ProfilepgState extends State<Profilepg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D5F5D),
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
      body: Body(
        value1: widget.value1,
        value2: widget.value2,
        value3: widget.value3,
        value4: widget.value4,
        value5: widget.value5,
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({
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
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 60,
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey[600],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Editpg(
                                value1: widget.value1,
                                value2: widget.value2,
                                value3: widget.value3,
                                value4: widget.value4,
                                value5: widget.value5,
                              ),
                            ),
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
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Card(
                  shadowColor: const Color(0xFF2D5F5D),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person),
                                Text(
                                  "   Name: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 34),
                              child: Text(widget.value1),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.phone),
                                Text(
                                  "   Contact No: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 34),
                              child: Text(widget.value2),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.mail),
                                Text(
                                  "   Email: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 34),
                              child: Text(widget.value3),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info),
                                Text(
                                  "   About",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 34),
                              child: Text(widget.value4),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}