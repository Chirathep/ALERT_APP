import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_alert/net/flutterfire.dart';
import 'package:flutter_app_alert/net/user_model.dart';
import 'package:flutter_app_alert/views/main/index.dart';
import 'package:flutter_app_alert/views/progress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileUI extends StatefulWidget {
  const EditProfileUI({Key? key}) : super(key: key);

  @override
  State<EditProfileUI> createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  //-------------------CAMERA-------------------//
  //start code: open camara
  XFile? imageFile;
  pickImage(sourceImage) async {
    //code open camera
    final photo = await ImagePicker().pickImage(
      source: sourceImage,
      imageQuality: 75,
      preferredCameraDevice: CameraDevice.rear,
    );
    //เอารูปที่ได้จาก camera/gallery ไปใช้งาน
    setState(() {
      imageFile = photo;
    });
  }

  //-------------------CAMERA-------------------//
  TextEditingController _nameController = TextEditingController();

  bool _nameValid = true;

  bool isLoading = false;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final Reference storageRef = FirebaseStorage.instance.ref();
  final usersRef = FirebaseFirestore.instance.collection('users');
  final postsRef = FirebaseFirestore.instance.collection('posts');

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.doc(user!.uid).get();
    loggedInUser = UserModel.fromDocument(doc);
    _nameController.text = loggedInUser.name!;
    setState(() {
      isLoading = false;
    });
  }

  //upload image to firestore
  Future<String> uploadImage(File image) async {
    UploadTask uploadTask =
        storageRef.child('profile_images/${user!.uid}').putFile(image);
    TaskSnapshot storageSnap =
        await uploadTask.whenComplete(() => print('Uploaded'));
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  Column buildDisplayNamefield() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 12.0,
            left: 30,
            right: 30,
          ),
          child: Text(
            'Name',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              if (val!.trim().length < 3 || val.isEmpty) {
                return 'ชื่อต้องมีความยาวอย่างน้อย 3 ตัวอักษร';
              } else if (val.trim().length > 10) {
                return 'ชื่อต้องมีความยาวไม่เกิน 10 ตัวอักษร';
              } else {
                return null;
              }
            },
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'กรุณากรอกชื่อของคุณ',
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {});
      print(this.loggedInUser.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//appbar edit profile
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'แก้ไขข้อมูลส่วนตัว',
          style: TextStyle(color: Colors.black),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.check,
        //       color: Colors.green,
        //     ),
        //     onPressed: () => Navigator.pop(context),
        //   ),
        //   SizedBox(
        //     width: 5,
        //   ),
        // ],
        centerTitle: true,
      ),
      body: isLoading
          ? circularProgress()
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: MediaQuery.of(context).size.height * 0.35,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 8,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.19,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageFile == null
                                      ? NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/flutter-alert-app.appspot.com/o/profile-icon.png?alt=media&token=da62b0f2-0f43-4530-8934-db7bf423aeb5',
                                        )
                                      : FileImage(
                                          File(imageFile!.path),
                                        ) as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 180, left: 200),
                              child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'เลือกรูปจาก\nกล้องหรืออัลบั้ม',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Divider(),
                                          //code: open camera
                                          ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              //open camera
                                              pickImage(ImageSource.camera);
                                            },
                                            leading: Icon(
                                              Icons.camera_alt,
                                              color: Colors.blue,
                                            ),
                                            title: Text('Camera/กล้องถ่ายรูป'),
                                          ),
                                          Divider(),
                                          //code: open gallery
                                          ListTile(
                                            onTap: () {
                                              //ปิด modal
                                              Navigator.pop(context);
                                              //เปิด gallery
                                              pickImage(ImageSource.gallery);
                                            },
                                            leading: Icon(
                                              Icons.photo_album,
                                              color: Colors.green,
                                            ),
                                            title: Text('Gallery/อัลบั้มรูป'),
                                          ),
                                          Divider(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey,
                                  size: 30.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              buildDisplayNamefield(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _nameController.text.trim().length < 3 ||
                                      _nameController.text.isEmpty ||
                                      _nameController.text.trim().length > 10
                                  ? _nameValid = false
                                  : _nameValid = true;
                            });
                            if (_nameValid) {
                              usersRef.doc(user!.uid).update(
                                {'name': _nameController.text},
                              );
                              usersRef.doc(user!.uid).update(
                                {'imageURL': imageFile},
                              );
                              Fluttertoast.showToast(
                                msg: "อัพเดตข้อมูลเรียบร้อย",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green[50],
                                textColor: Colors.black,
                                fontSize: 16.0,
                              );
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(
                                msg: "กรุณากรอกข้อมูลให้ถูกต้อง",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor:
                                    Color.fromARGB(255, 235, 198, 198),
                                textColor: Colors.black,
                                fontSize: 16.0,
                              );
                            }
                          },
                          child: Text(
                            'อัพเดทข้อมูล',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.blueAccent[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.grey,
                            primary: Color.fromARGB(255, 219, 219, 219),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 140,
                            right: 140,
                          ),
                          child: InkWell(
                            onTap: () async {
                              await AuthClass().logout();
                              {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => IndexUI()),
                                );
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.exit_to_app,
                                  color: Colors.red,
                                ),
                                Text(
                                  'ออกจากระบบ',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
