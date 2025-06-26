import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class Viewprofile extends StatefulWidget {
  final String email;
  final String userName;
  final String imageUrl;
  final String password;
  final String phoneNumber;
  final String customerId;

  const Viewprofile({
    super.key,
    required this.email,
    required this.password,
    required this.userName,
    required this.imageUrl,
    required this.phoneNumber,
    required this.customerId,
  });

  @override
  State<Viewprofile> createState() => _ViewprofileState();
}

class _ViewprofileState extends State<Viewprofile> {
  bool _obscurePassword = true;

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  File? imageFile;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phoneNumber);
    _passwordController = TextEditingController(text: widget.password);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<void> _requestOtpAndUpdateProfile() async {
    final sendOtpUri = Uri.parse(
      "https://leez-app.onrender.com/api/customer/get-update-otp",
    );

    try {
      final response = await http.post(
        sendOtpUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "phoneNo": _phoneController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("OTP sent successfully")));
        String? otp = await _showOtpDialog();
        if (otp != null) {
          await _updateProfile(otp);
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to send OTP")));
      }
    } catch (e) {
      print("Error sending OTP: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error sending OTP")));
    }
  }

  Future<String?> _showOtpDialog() async {
    List<TextEditingController> controllers = List.generate(
      4,
      (_) => TextEditingController(),
    );
    List<FocusNode> nodes = List.generate(4, (_) => FocusNode());
    String? otpResult;

    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Enter 4-digit OTP"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                return Container(
                  width: 40,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: TextField(
                    controller: controllers[i],
                    focusNode: nodes[i],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        if (i < 3)
                          nodes[i + 1].requestFocus();
                        else
                          nodes[i].unfocus();
                      } else {
                        if (i > 0) nodes[i - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  String otp = controllers.map((c) => c.text).join();
                  if (otp.length == 4 &&
                      otp.runes.every((r) => r >= 48 && r <= 57)) {
                    otpResult = otp;
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Enter valid 4-digit OTP")),
                    );
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
    );

    return otpResult;
  }

  Future<void> _updateProfile(String otp) async {
    final uri = Uri.parse(
      "https://leez-app.onrender.com/api/customer/update-profile",
    );
    final request = http.MultipartRequest("POST", uri);

    request.fields['customerId'] = widget.customerId;
    request.fields['email'] = _emailController.text.trim();
    request.fields['name'] = _usernameController.text.trim();
    request.fields['phoneNo'] = _phoneController.text.trim();
    request.fields['password'] = _passwordController.text.trim();
    request.fields['otp'] = otp;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          imageFile!.path,
          filename: 'photo.jpg',
        ),
      );
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        _showUpdateResultDialog(true);
      } else {
        _showUpdateResultDialog(false);
      }
    } catch (e) {
      print("Update error: $e");
      _showUpdateResultDialog(false);
    }
  }

  void _showUpdateResultDialog(bool success) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(success ? "Success" : "Failed"),
            content: Text(
              success
                  ? "Profile updated successfully"
                  : "Profile update failed",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  if (success) {
                    Navigator.pop(context, true); // Return true to ProfilePage
                  }
                },
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("View Profile", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: width * 0.36, // Diameter (same as 2 * radius)
                  height: width * 0.36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image:
                          imageFile != null
                              ? FileImage(imageFile!)
                              : NetworkImage(widget.imageUrl) as ImageProvider,
                      fit:
                          BoxFit
                              .fitHeight, // Make sure it fills the circle nicely
                    ),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _pickImage,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildTextField("Username", _usernameController),
            _buildTextField("Email", _emailController),
            _buildTextField("Phone", _phoneController),
            _buildPasswordField(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _requestOtpAndUpdateProfile,
              child: Text("Update Profile"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
      ),
    );
  }
}
