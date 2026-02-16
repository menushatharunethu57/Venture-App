import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
  final _imagePicker = ImagePicker();

  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController about = TextEditingController();

  bool _isSaving = false;
  File? _selectedImage;
  String? _currentProfilePictureUrl;

  @override
  void initState() {
    super.initState();
    name.text = widget.value1;
    contact.text = widget.value2;
    mail.text = widget.value3;
    about.text = widget.value4;
    _currentProfilePictureUrl = widget.value5.isEmpty ? null : widget.value5;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Profile Picture',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D5F5D),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: const Color(0xFF2D5F5D),
                  ),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_library,
                    color: const Color(0xFF2D5F5D),
                  ),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (_currentProfilePictureUrl != null || _selectedImage != null)
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.redAccent),
                    title: const Text('Remove Photo'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedImage = null;
                        _currentProfilePictureUrl = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _uploadProfilePicture(File imageFile) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No user logged in');

      final fileExt = imageFile.path.split('.').last;
      final fileName =
          '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'profile-pictures/$fileName';

      // Upload to Supabase Storage
      await _supabase.storage
          .from('profile-pictures')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // Get public URL
      final publicUrl = _supabase.storage
          .from('profile-pictures')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> _deleteOldProfilePicture(String oldUrl) async {
    try {
      // Extract file path from URL
      final uri = Uri.parse(oldUrl);
      final pathSegments = uri.pathSegments;

      if (pathSegments.length >= 2) {
        final filePath = pathSegments
            .sublist(pathSegments.length - 2)
            .join('/');
        await _supabase.storage.from('profile-pictures').remove([filePath]);
      }
    } catch (e) {
      debugPrint('Error deleting old profile picture: $e');
      // Don't throw - this is not critical
    }
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

      String? profilePictureUrl = _currentProfilePictureUrl;

      // Upload new image if selected
      if (_selectedImage != null) {
        // Delete old profile picture if exists
        if (_currentProfilePictureUrl != null &&
            _currentProfilePictureUrl!.isNotEmpty) {
          await _deleteOldProfilePicture(_currentProfilePictureUrl!);
        }

        profilePictureUrl = await _uploadProfilePicture(_selectedImage!);
      } else if (_currentProfilePictureUrl == null &&
          widget.value5.isNotEmpty) {
        // User removed the profile picture
        await _deleteOldProfilePicture(widget.value5);
      }

      // Update profile in Supabase
      await _supabase.from('user_profiles').upsert({
        'id': userId,
        'name': name.text.trim(),
        'phone': contact.text.trim(),
        'email': mail.text.trim(),
        'about': about.text.trim(),
        'profile_picture_url': profilePictureUrl,
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
        selectedImage: _selectedImage,
        currentProfilePictureUrl: _currentProfilePictureUrl,
        onImageTap: _showImageSourceDialog,
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
    required this.selectedImage,
    required this.currentProfilePictureUrl,
    required this.onImageTap,
  });

  final TextEditingController name;
  final TextEditingController contact;
  final TextEditingController mail;
  final TextEditingController about;
  final bool isSaving;
  final VoidCallback onSave;
  final File? selectedImage;
  final String? currentProfilePictureUrl;
  final VoidCallback onImageTap;

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
                  GestureDetector(
                    onTap: onImageTap,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 60,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : (currentProfilePictureUrl != null &&
                                        currentProfilePictureUrl!.isNotEmpty
                                    ? NetworkImage(currentProfilePictureUrl!)
                                    : null)
                                as ImageProvider?,
                      child:
                          (selectedImage == null &&
                              (currentProfilePictureUrl == null ||
                                  currentProfilePictureUrl!.isEmpty))
                          ? Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey[600],
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: onImageTap,
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
