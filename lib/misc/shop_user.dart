import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShopUser {
  final String id;
  final String fullname;
  final String? profilePictureBase64;
  final bool isAdmin;

  ShopUser({
    required this.id,
    required this.fullname,
    this.profilePictureBase64,
    required this.isAdmin,
  });

  static Future<ShopUser> fromJson(Map<String, dynamic> json) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String? profilePictureBase64;
    try {
      var profilePictureData = await storage.ref().child('profilePictures/${json['id']}').getData();
      if (profilePictureData != null) {
        profilePictureBase64 = base64Encode(profilePictureData);
      }
    } catch (e) {
      profilePictureBase64 = null;
    }
    return ShopUser(
      id: json['id'],
      fullname: json['fullname'],
      profilePictureBase64: profilePictureBase64,
      isAdmin: json['isAdmin'],
    );
  }

  static Future<ShopUser> getFromId(String id) async {
    var response = await http.get(Uri.parse('http://15.237.20.86:3000/auth/getUserDetails/$id'));
    if (response.statusCode == 200) {
      var userDetails = json.decode(response.body);
      FirebaseStorage storage = FirebaseStorage.instance;
      String? profilePictureBase64;
      try {
        var profilePictureData = await storage.ref().child('profilePictures/$id').getData();
        if (profilePictureData != null) {
          profilePictureBase64 = base64Encode(profilePictureData);
        }
      } catch (e) {
        profilePictureBase64 = null;
      }
      return ShopUser(
        id: id,
        profilePictureBase64: profilePictureBase64,
        fullname: userDetails['fullname'],
        isAdmin: userDetails['isAdmin'],
      );
    } else {
      return ShopUser(
        id: id,
        fullname: 'Unknown',
        isAdmin: false,
      );
    }
  }
}