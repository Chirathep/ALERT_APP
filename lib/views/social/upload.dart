import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_alert/views/progress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController _locationController = TextEditingController();
  TextEditingController _captionController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  final Reference storageRef = FirebaseStorage.instance.ref();

  //userRef
  final usersRef = FirebaseFirestore.instance.collection('users');
  final postsRef = FirebaseFirestore.instance.collection('posts');
  final markersRef = FirebaseFirestore.instance.collection('markers');

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {});
    super.initState();
  }

  String dropdownvalue = 'กรุงเทพมหานคร';
  var items = [
    'กรุงเทพมหานคร',
    'กระบี่',
    'กาญจนบุรี',
    'กาฬสินธุ์',
    'กำแพงเพชร',
    'ขอนแก่น',
    'จันทบุรี',
    'ฉะเชิงเทรา',
    'ชลบุรี',
    'ชัยนาท',
    'ชัยภูมิ',
    'ชุมพร',
    'เชียงราย',
    'เชียงใหม่',
    'ตรัง',
    'ตราด',
    'ตาก',
    'นครนายก',
    'นครปฐม',
    'นครพนม',
    'นครราชสีมา',
    'นครศรีธรรมราช',
    'นครสวรรค์',
    'นนทบุรี',
    'นราธิวาส',
    'น่าน',
    'บึงกาฬ',
    'บุรีรัมย์',
    'ปทุมธานี',
    'ประจวบคีรีขันธ์',
    'ปราจีนบุรี',
    'ปัตตานี',
    'พระนครศรีอยุธยา',
    'พะเยา',
    'พังงา',
    'พัทลุง',
    'พิจิตร',
    'พิษณุโลก',
    'เพชรบุรี',
    'เพชรบูรณ์',
    'แพร่',
    'ภูเก็ต',
    'มหาสารคาม',
    'มุกดาหาร',
    'แม่ฮ่องสอน',
    'ยะลา',
    'ยโสธร',
    'ร้อยเอ็ด',
    'ระนอง',
    'ระยอง',
    'ราชบุรี',
    'ลพบุรี',
    'ลำปาง',
    'ลำพูน',
    'เลย',
    'ศรีสะเกษ',
    'สกลนคร',
    'สงขลา',
    'สตูล',
    'สมุทรปราการ',
    'สมุทรสงคราม',
    'สมุทรสาคร',
    'สระแก้ว',
    'สระบุรี',
    'สิงห์บุรี',
    'สุโขทัย',
    'สุพรรณบุรี',
    'สุราษฎร์ธานี',
    'สุรินทร์',
    'หนองคาย',
    'หนองบัวลำภู',
    'อ่างทอง',
    'อำนาจเจริญ',
    'อุดรธานี',
    'อุตรดิตถ์',
    'อุทัยธานี',
    'อุบลราชธานี',
  ];
  bool isUploading = false;
  File? file;
  String postId = Uuid().v4();
  bool gpsicon = false;

  ///map////
  late LocationData currentPosition = LocationData.fromMap({});
  Location location = Location();
  String myLocation = "no";
  LatLng initialcamerapoisition = LatLng(13.707376, 100.356107);
  getLoc() async {
    myLocation = "yes";
    print('myLocation $myLocation');
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    currentPosition = await location.getLocation();
    double? latitude = currentPosition.latitude;
    double? longitude = currentPosition.longitude;

    Location.instance.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        print(
            'Current Loc ${currentLocation.latitude} : ${currentLocation.longitude}');
        initialcamerapoisition = LatLng(latitude!, longitude!);
        return;
      });
    });
  }

  ///map////
  Future handleTakePhoto() async {
    try {
      Navigator.pop(context);
      final file = await ImagePicker()
          .pickImage(source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
      if (file == null) return;
      final fileTemp = File(file.path);
      setState(() {
        this.file = fileTemp;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future handleChooseFromGallery() async {
    //imagepicker
    try {
      Navigator.pop(context);
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) return;
      final fileTemp = File(file.path);
      setState(() {
        this.file = fileTemp;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  selectImage(parentcontext) {
    return showDialog(
      context: parentcontext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            'สร้างโพส',
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('รูปจากกล้อง'),
              onPressed: handleTakePhoto,
            ),
            SimpleDialogOption(
              child: Text('รูปจากคลัง'),
              onPressed: handleChooseFromGallery,
            ),
            SimpleDialogOption(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Container buildSplashScreen() {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  //border color
                  backgroundColor: Colors.white,
                  radius: 25,
                  backgroundImage: NetworkImage(
                    'https://icons.iconarchive.com/icons/paomedia/small-n-flat/256/profile-icon.png',
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                StreamBuilder(
                  stream: usersRef.doc(user!.uid).snapshots(),
                  initialData: null,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return circularProgress();
                    }
                    final DocumentSnapshot doc = snapshot.data;
                    return Text(
                      doc['name'],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  selectImage(context);
                },
                child: Text(
                  'อัพโหลดรูปภาพ',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
      _captionController.clear();
      _locationController.clear();
      isUploading = false;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    Im.Image? imageFile = Im.decodeImage(file!.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  //upload image to firebase
  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask =
        storageRef.child('post_$postId.jpg').putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() {
      print('Uploaded');
    });
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createPostInFirestore({
    String? mediaURL,
    String? location,
    String? description,
    String? nameFinal,
  }) {
    postsRef.doc(user!.uid).collection("userPosts").doc(postId).set(
      {
        "postId": postId,
        "userId": user?.uid,
        "name": nameFinal,
        "mediaURL": mediaURL,
        "description": description,
        "location": location,
        "likes": {},
        "timestamp": DateTime.now(),
      },
    );
  }

  createMapInFirestore({
    String? location,
    String? latitude,
    String? longitude,
  }) {
    markersRef.doc(user?.uid).collection("userMap").doc(postId).set(
      {
        "postId": postId,
        "userId": user?.uid,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "timestamp": DateTime.now(),
      },
    );
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaURL = await uploadImage(file);
    String nameFinal = await usersRef.doc(user!.uid).get().then((value) {
      return value.data()!['name'];
    });

    createPostInFirestore(
      nameFinal: nameFinal,
      mediaURL: mediaURL,
      location: _locationController.text,
      description: _captionController.text,
    );
    createMapInFirestore(
      location: _locationController.text,
      latitude: currentPosition.latitude.toString(),
      longitude: currentPosition.longitude.toString(),
    );
    _captionController.clear();
    _locationController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => SocialUI()));
    Navigator.pop(context);
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'สร้างโพสต์',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 1,
        backgroundColor: Colors.grey[50],
        //button submit post
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0, top: 13.0, bottom: 10),
            child: InkWell(
              onTap: () {
                clearImage();
              },
              child: Text(
                'ล้างข้อมูล',
                style: TextStyle(
                    color: Colors.red[300],
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: <Widget>[
            isUploading ? linearProgress() : Text(''),
            Container(
              height: 220.00,
              width: MediaQuery.of(context).size.width * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                            'https://icons.iconarchive.com/icons/paomedia/small-n-flat/256/profile-icon.png',
                          ),
                        ),
                        SizedBox(width: 20),
                        StreamBuilder(
                          stream: usersRef.doc(user!.uid).snapshots(),
                          initialData: null,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return circularProgress();
                            }
                            final DocumentSnapshot doc = snapshot.data;
                            return Text(
                              doc['name'],
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 20.0, right: 20.0),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: file != null
                            ? Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(file!),
                                  ),
                                ),
                              )
                            : Container(
                                child: TextField(
                                  controller: _captionController,
                                  maxLines: null,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                  decoration: InputDecoration(
                                    hintText: 'ระบุรายละเอียด...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                title: Container(
                  width: 250.0,
                  child: file != null
                      ? TextField(
                          controller: _captionController,
                          decoration: InputDecoration(
                            hintText: 'ระบุรายละเอียด',
                            border: InputBorder.none,
                          ),
                        )
                      : TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                          ),
                        ),
                ),
              ),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    getLoc();
                    setState(() {
                      gpsicon = true;
                    });
                  },
                  icon: gpsicon
                      ? Icon(
                          Icons.gps_fixed,
                          color: Colors.blue[600],
                        )
                      : Icon(
                          Icons.gps_not_fixed,
                          color: Colors.grey[600],
                        ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                    width: 250,
                    child: DropdownButton(
                      // Initial Value
                      value: dropdownvalue,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),
//none borderline
                      isExpanded: true,
                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                          _locationController.text = dropdownvalue;
                        });
                      },
                    )),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    selectImage(context);
                  },
                  icon: Icon(
                    Icons.photo_camera,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              color: Colors.grey,
            ),
            Container(
              width: 200,
              height: 100.0,
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: isUploading ? null : () => handleSubmit(),
                child: Text('ยืนยันข้อมูล'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),

            // ElevatedButton(
            //   onPressed: () {
            //     print(userName());
            //   },
            //   child: Text('test'),
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.blue,
            //     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // getUserLocation() async {
  //   //geolocator: ^8.2.0 style
  //   Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   List<Placemark> placemark = await geolocator.placemarkFromCoordinates(
  //       position.latitude, position.longitude);
  //   Placemark mPlacemark = placemark[0];
  //   String formattedAddress =
  //       '${mPlacemark.subThoroughfare} ${mPlacemark.thoroughfare}, ${mPlacemark.subLocality} ${mPlacemark.locality}, ${mPlacemark.subAdministrativeArea} ${mPlacemark.administrativeArea}, ${mPlacemark.postalCode} ${mPlacemark.country}';
  //   _locationController.text = formattedAddress;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: buildUploadForm(),
    );
  }
}
