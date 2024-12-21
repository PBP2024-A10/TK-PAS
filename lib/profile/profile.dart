import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart' as pbp;
import 'package:provider/provider.dart';
import 'package:ajengan_halal_mobile/base/style/colors.dart';
import 'package:ajengan_halal_mobile/auth/screens/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  String successMessage = '';
  String errorMessage = '';
  String displayedUsername = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProfileData();
    });
  }

  Future<void> _fetchProfileData() async {
    try {
      var request = context.read<pbp.CookieRequest>();
      
      // Fetch fresh profile data from server
      final response = await request.get(
        'http://127.0.0.1:8000/profile/get-profile-flutter/'  // Tambahkan endpoint ini di Django
      );

      if (response != null) {
        setState(() {
          displayedUsername = response['username'] ?? '';
          _usernameController.text = response['username'] ?? '';
          _firstNameController.text = response['first_name'] ?? '';
          _lastNameController.text = response['last_name'] ?? '';
          _bioController.text = response['bio'] ?? '';
          
          // Update jsonData with latest values
          request.jsonData['username'] = response['username'];
          request.jsonData['first_name'] = response['first_name'];
          request.jsonData['last_name'] = response['last_name'];
          request.jsonData['bio'] = response['bio'];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch profile data: $e';
      });
    }
  }


  // New method to handle API call
  Future<void> _updateProfile() async {
  setState(() {
    isLoading = true;
    errorMessage = '';
    successMessage = '';
  });

  try {
    var request = context.read<pbp.CookieRequest>();
    
    // Create a complete form data object
    final formData = {
      'username': _usernameController.text,  // Only if your UserUpdateForm expects username
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'bio': _bioController.text,
      // Add any other fields that your UserUpdateForm and ProfileUpdateForm require
    };

    final response = await request.postJson(
      'http://127.0.0.1:8000/profile/update-profile-flutter/',
      jsonEncode(formData),
    );

    if (response['status'] == 'success') {
      setState(() {
        successMessage = 'Profile updated successfully!';
        // Update the stored user data
        request.jsonData['first_name'] = _firstNameController.text;
        request.jsonData['last_name'] = _lastNameController.text;
        request.jsonData['bio'] = _bioController.text;
      });
    } else {
      setState(() {
        // Handle specific validation errors if they exist
        if (response['errors'] != null) {
          errorMessage = 'Validation errors: ${response['errors'].toString()}';
        } else {
          errorMessage = response['message'] ?? 'Failed to update profile';
        }
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = 'Error updating profile: $e';
    });
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  void _submitForm() {
    if (_bioController.text.isEmpty && _firstNameController.text.isEmpty && _lastNameController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in one of the below fields';
        successMessage = '';
      });
      return;
    }
    _updateProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile'),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Picture Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFE8DCD4),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Profile Picture',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3D200A)),
                  ),
                  SizedBox(height: 16),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/user.png'),
                  ),
                  SizedBox(height: 8),
                  // Tampilkan nama pengguna yang sedang login
                  Text(
                    displayedUsername.isNotEmpty ? displayedUsername : 'Loading username...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3D200A),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Account Details Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFE8DCD4),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3D200A)),
                  ),
                  SizedBox(height: 16),

                  // Display Success or Error Message
                  if (successMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        successMessage,
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),            
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(labelText: 'First Name'),
                  ),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(labelText: 'Last Name'),
                  ),
                  TextField(
                    controller: _bioController,
                    decoration: InputDecoration(labelText: 'Bio'),
                    maxLines: 3,
                  ),

                  // Submit Button
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
