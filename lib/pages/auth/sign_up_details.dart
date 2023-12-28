import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart';
import 'package:path/path.dart' as path;

import 'package:dio/dio.dart';

class SignupDetails extends StatefulWidget {
  @override
  _SignupDetailsState createState() => _SignupDetailsState();
}

class _SignupDetailsState extends State<SignupDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController accessCodeController = TextEditingController();
  String? _imageBase64;
  bool isAdmin = false;
  bool _isAccessCodeSectionEnabled = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(imageBytes);
      });
    }
  }

  Future<void> _verifyAccessCode() async {
    var response = await http.get(Uri.parse('http://15.237.20.86:3000/auth/checkAdminAccessCode?key=${accessCodeController.text}'));

    if (response.statusCode == 200 && json.decode(response.body)['valid']) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Access code valid'),
        backgroundColor: Colors.green,
      ));
      setState(() {
        isAdmin = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invalid access code'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _updateProfileDetails() async {
    var userId = await SharedPreferences.getInstance().then((prefs) => prefs.getString('userID'));
    var dio = Dio();
    var uri = 'http://15.237.20.86:3000/auth/setUserDetails/$userId';

    try {
      var response = await dio.post(uri, data: {
        'fullname': nameController.text,
        'profilePicture': 'test',
        'isAdmin': isAdmin.toString(),
      });

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('signUpEditingMode', false);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User details updated'),
        ));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error updating profile details: ${response.data}'),
          backgroundColor: Colors.red,
        ));
      }
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Dio error: ${e.response?.data.toString() ?? e.message}'),
        backgroundColor: Colors.red,
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageBase64 != null ? MemoryImage(base64Decode(_imageBase64!)) : null,
                child: _imageBase64 == null ? const Icon(Icons.camera_alt, size: 50) : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _isAccessCodeSectionEnabled,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAccessCodeSectionEnabled = value!;
                    });
                  },
                ),
                const Text("Do you have an access code?")
              ],
            ),
            if (_isAccessCodeSectionEnabled) ...[
              TextField(
                controller: accessCodeController,
                decoration: const InputDecoration(labelText: 'Access Code'),
              ),
              ElevatedButton(
                onPressed: _verifyAccessCode,
                child: const Text('Verify Code'),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfileDetails,
              child: const Text('Update Profile Details'),
            ),
          ],
        ),
      ),
    );
  }
}