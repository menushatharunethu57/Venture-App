import 'dart:typed_data';
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

  Uint8List? _selectedImageBytes;
  String? _selectedImageExt;
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

  /// Safely resolve the file extension from an XFile.
  /// On web, XFile.path is a blob URL so we must use XFile.name or mimeType.
  String _getExtension(XFile file) {
    // 1. Try XFile.name (e.g. "photo.jpg") — works on web and mobile
    final name = file.name;
    if (name.contains('.')) {
      final ext = name.split('.').last.toLowerCase();
      if (ext.isNotEmpty && !ext.contains('/') && !ext.contains(':')) {
        return ext;
      }
    }

    // 2. Try mimeType (e.g. "image/jpeg") — available on most platforms
    final mime = file.mimeType;
    if (mime != null && mime.contains('/')) {
      final sub = mime.split('/').last.toLowerCase();
      // Normalize "jpeg" aliases
      if (sub == 'jpeg') return 'jpg';
      return sub;
    }

    // 3. Fallback
    return 'jpg';
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
        final bytes = await pickedFile.readAsBytes();
        final ext = _getExtension(pickedFile);

        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageExt = ext;
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
                const Text(
                  'Choose Profile Picture',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D5F5D),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Color(0xFF2D5F5D),
                  ),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Color(0xFF2D5F5D),
                  ),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (_currentProfilePictureUrl != null ||
                    _selectedImageBytes != null)
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.redAccent),
                    title: const Text('Remove Photo'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedImageBytes = null;
                        _selectedImageExt = null;
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

  Future<String?> _uploadProfilePicture(Uint8List bytes, String fileExt) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No user logged in');

      final fileName =
          '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'profile-pictures/$fileName';

      // contentType must be a clean "image/jpg" — never a blob URL
      final contentType = 'image/$fileExt';

      await _supabase.storage
          .from('profile-pictures')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(
              cacheControl: '3600',
              upsert: true,
              contentType: contentType,
            ),
          );

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
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No user logged in');

      String? profilePictureUrl = _currentProfilePictureUrl;

      if (_selectedImageBytes != null && _selectedImageExt != null) {
        if (_currentProfilePictureUrl != null &&
            _currentProfilePictureUrl!.isNotEmpty) {
          await _deleteOldProfilePicture(_currentProfilePictureUrl!);
        }
        profilePictureUrl = await _uploadProfilePicture(
          _selectedImageBytes!,
          _selectedImageExt!,
        );
      } else if (_currentProfilePictureUrl == null &&
          widget.value5.isNotEmpty) {
        await _deleteOldProfilePicture(widget.value5);
      }

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
        Navigator.pop(context, true);
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
        title: const Text(
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
        selectedImageBytes: _selectedImageBytes,
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
    required this.selectedImageBytes,
    required this.currentProfilePictureUrl,
    required this.onImageTap,
  });

  final TextEditingController name;
  final TextEditingController contact;
  final TextEditingController mail;
  final TextEditingController about;
  final bool isSaving;
  final VoidCallback onSave;
  final Uint8List? selectedImageBytes;
  final String? currentProfilePictureUrl;
  final VoidCallback onImageTap;

  ImageProvider? _resolveImage() {
    if (selectedImageBytes != null) {
      return MemoryImage(selectedImageBytes!);
    }
    if (currentProfilePictureUrl != null &&
        currentProfilePictureUrl!.isNotEmpty) {
      return NetworkImage(currentProfilePictureUrl!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _resolveImage();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: onImageTap,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 60,
                      backgroundImage: imageProvider,
                      child: imageProvider == null
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D5F5D),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
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
            const SizedBox(height: 50),
            TextField(
              controller: name,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: contact,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone),
                labelText: "Contact No",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: mail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: about,
              maxLines: 4,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.info),
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
