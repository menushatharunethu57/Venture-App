import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final _supabase = Supabase.instance.client;
  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController about = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    name.text = widget.value1;
    contact.text = widget.value2;
    mail.text = widget.value3;
    about.text = widget.value4;
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('No user logged in');
      }

      // Update profile in Supabase
      await _supabase.from('user_profiles').upsert({
        'id': userId,
        'name': name.text.trim(),
        'phone': contact.text.trim(),
        'email': mail.text.trim(),
        'about': about.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Color(0xFF2D5F5D),
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Body(
        name: name,
        contact: contact,
        mail: mail,
        about: about,
        isSaving: _isSaving,
        onSave: _saveProfile,
      ),
    );
  }

  @override
  void dispose() {
    name.dispose();
    contact.dispose();
    mail.dispose();
    about.dispose();
    super.dispose();
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
    required this.name,
    required this.contact,
    required this.mail,
    required this.about,
    required this.isSaving,
    required this.onSave,
  });

  final TextEditingController name;
  final TextEditingController contact;
  final TextEditingController mail;
  final TextEditingController about;
  final bool isSaving;
  final VoidCallback onSave;

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
                child: Icon(Icons.person, size: 80, color: Colors.grey[600]),
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
              keyboardType: TextInputType.phone,
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
              keyboardType: TextInputType.emailAddress,
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
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 57,
              child: ElevatedButton(
                onPressed: isSaving ? null : onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D5F5D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
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