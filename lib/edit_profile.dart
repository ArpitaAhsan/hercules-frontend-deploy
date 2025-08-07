import 'package:flutter/material.dart';
import 'package:hercules/component/toolbar.dart';
import 'package:hercules/component/app_text_field.dart';
import 'package:hercules/config/app_string.dart';
import 'package:hercules/styles/app_colors.dart';
import 'package:hercules/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hercules/config/app_routes.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  String userId = "";

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  void _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? "";
    });
    if (userId.isNotEmpty) {
      _fetchUserProfile(userId);
    }
  }

  void _fetchUserProfile(String userId) async {
    final response = await ApiService.fetchUserProfile(userId);
    if (response['error'] == null) {
      setState(() {
        _nameController.text = response['name'] ?? "";
        _phoneController.text = response['phone'] ?? "";
        _countryController.text = response['country'] ?? "";
      });
    } else {
      print("❌ Error fetching profile: ${response['error']}");
    }
  }

  void _updateProfile() async {
    final response = await ApiService.updateUserProfile(
      userId: userId,
      name: _nameController.text,
      phone: _phoneController.text,
      country: _countryController.text,
    );

    if (response['error'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.profile, (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['error'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.blue[200],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // Name Field
              _buildPastelInputField(
                controller: _nameController,
                hintText: "Name",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),

              // Phone Field
              _buildPastelInputField(
                controller: _phoneController,
                hintText: "Phone Number",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              // Country Field
              _buildPastelInputField(
                controller: _countryController,
                hintText: "Country",
                icon: Icons.flag_outlined,
              ),
              const SizedBox(height: 40),

              // Save Button with pastel background
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8FCBFF), // pastel blue
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: const Color(0xFF8FCBFF).withOpacity(0.5),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPastelInputField({
    required TextEditingController controller,
    required String hintText,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFDAF0FF), // pastel light blue background
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF8FCBFF)) : null,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black45),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }
}
