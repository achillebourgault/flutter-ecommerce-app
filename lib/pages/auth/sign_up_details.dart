import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../misc/shop_user.dart';
import '../../redux/store.dart';

import 'package:dio/dio.dart';

class SignupDetails extends StatefulWidget {
  const SignupDetails({Key? key}) : super(key: key);
  @override
  State<SignupDetails> createState() => _SignupDetailsState();
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
      List<int> imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(imageBytes);
      });
    }
  }

  void _verifyAccessCode() {
    http.get(Uri.parse('http://15.237.20.86:3000/auth/checkAdminAccessCode?key=${accessCodeController.text}')).then((response) {
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
    });
  }

  _updateProfileDetails() {
    SharedPreferences.getInstance().then((prefs) => prefs.getString('userID')).then((userId) {
      var dio = Dio();
      var uri = 'http://15.237.20.86:3000/auth/setUserDetails/$userId';

      if (_imageBase64 != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        storage.ref().child('profilePictures/$userId').putData(base64Decode(_imageBase64!));
      }

      if (nameController.text == '') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.red,
        ));
        return;
      }

      try {
        dio.post(uri, data: {
          'fullname': nameController.text,
          'profilePicture': 'unused field',
          'isAdmin': isAdmin,
        }).then((response) {

          if (response.statusCode == 200) {
            SharedPreferences.getInstance().then((prefs) => prefs.setBool('signUpEditingMode', false));
            ShopUser.getFromId(userId!).then((user) {
              StoreProvider.of<ShopState>(context).dispatch(SetUserAction(user));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('User details updated'),
              ));
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error updating profile details: ${response.data}'),
              backgroundColor: Colors.red,
            ));
          }
        });
      } on DioException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Dio error: ${e.response?.data.toString() ?? e.message}'),
          backgroundColor: Colors.red,
        ));
      }
    });
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
            InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageBase64 != null ? MemoryImage(base64Decode(_imageBase64!)) : null,
                child: 
                _imageBase64 == null ? const Icon(Icons.camera_alt, size: 50) : null,
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
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(210, 210, 210, 1.0),
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 17),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
                ),
                onPressed: _verifyAccessCode,
                child: const Text('Verify code'),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 17),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
              ),
              onPressed: _updateProfileDetails,
              child: const Text('Update profile details'),
            ),
          ],
        ),
      ),
    );
  }
}