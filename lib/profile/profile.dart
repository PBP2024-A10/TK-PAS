import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart' as pbp;
import 'package:provider/provider.dart';
import 'package:ajengan_halal_mobile/base/style/colors.dart';
import 'package:ajengan_halal_mobile/auth/screens/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ajengan_halal_mobile/base/widgets/navbar.dart';

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

  @override
  void initState() {
    super.initState();
    // Ambil username dari data yang tersimpan di CookieRequest
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var request = context.read<pbp.CookieRequest>();

      if (request.jsonData.containsKey('username')) {
        setState(() {
          displayedUsername = request.jsonData['username'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        iconTheme: const IconThemeData(color: Colors.white),
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

  // Submit form logic
  void _submitForm() {
    setState(() {
      if (_bioController.text.isEmpty && _firstNameController.text.isEmpty && _lastNameController.text.isEmpty) {
        errorMessage = 'Please fill in one of the below fields';
        successMessage = '';
      } else {
        successMessage = 'Profile updated successfully!';
        errorMessage = '';
      }
    });
  }
}
