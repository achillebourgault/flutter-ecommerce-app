import 'dart:convert';
import 'dart:typed_data';
import 'package:ecommerce_app/misc/shop_user.dart';
import 'package:ecommerce_app/misc/string_extension.dart';
import 'package:ecommerce_app/pages/admin/index.dart';
import 'package:ecommerce_app/redux/store.dart';
import 'package:ecommerce_app/widgets/common/clickable_avatar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId != null) {
      var response = await http.get(Uri.parse('http://15.237.20.86:3000/auth/getUserDetails/$userId'));
      if (response.statusCode == 200) {
        var userDetails = json.decode(response.body);
        setState(() {
          isAdmin = userDetails['isAdmin'] ?? false;
        });
      }
    }
  }

  void _disconnectUser() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('userID');
      prefs.remove('signUpEditingMode');

      StoreProvider.of<ShopState>(context).dispatch(ClearUserAction());

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Disconnected successfully'),
        backgroundColor: Colors.green,
      ));

      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  void _pickImage(ShopUser user) {
    ImagePicker().pickImage(source: ImageSource.gallery).then((pickedFile) {
      if (pickedFile != null) {
        pickedFile.readAsBytes().then((imageBytes) {
          FirebaseStorage storage = FirebaseStorage.instance;
          storage.ref().child('profilePictures/${user.id}').putData(Uint8List.fromList(imageBytes)).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Profile picture updated'),
            ));
            StoreProvider.of<ShopState>(context).dispatch(SetUserAction(ShopUser(
                id: user.id,
                fullname: user.fullname,
                profilePictureBase64: base64Encode(imageBytes),
                isAdmin: user.isAdmin,
              )));
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<ShopState, ShopUser>(
      converter: (store) => store.state.user!,
      builder: (context, user) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Container(
                  width: 200,
                  height: 200,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClickableAvatar(
                    image: user.profilePictureBase64 != null ? MemoryImage(base64Decode(user.profilePictureBase64!)) : null,
                    onTap: () => _pickImage(user),
                    child: Stack(
                      children: <Widget>[
                        if (user.profilePictureBase64 == null)
                          Container(
                            color: Colors.blueGrey,
                            alignment: Alignment.center,
                            child: Text(
                              user.fullname.getInitials(),
                              style: const TextStyle(color: Colors.white, fontSize: 72),
                            ),
                          ),
                        Container(
                          alignment: Alignment.center,
                          color: Colors.black.withOpacity(0.5),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Color.fromARGB(200, 255, 255, 255),
                            size: 50
                          ),
                        )
                      ]
                      
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  user.fullname,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 20),
                if (isAdmin)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 17),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const AdminIndexPage()),
                      );
                    },
                    child: const Text('Admin Area'),
                  ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 17),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
                  ),
                  onPressed: _disconnectUser,
                  child: const Text('Disconnect'),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
