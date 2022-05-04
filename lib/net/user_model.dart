import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? name;
  String? photoURL;
  String? birthday;
  String? tel;
  String? password;
  String? admin;
  String? postsCount;

  String? timestamp;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.photoURL,
    this.birthday,
    this.tel,
    this.password,
    this.admin,
    this.postsCount,
    this.timestamp,
  });

//firestore
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['uid'],
      email: doc['email'],
      name: doc['name'],
      photoURL: doc['photoURL'],
      birthday: doc['birthday'],
      tel: doc['tel'],
      password: doc['password'],
      admin: doc['admin'],
      postsCount: doc['postsCount'],
      timestamp: doc['timestamp'],
    );
  }

  // Object? get displayName => null;

  // sending data to firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoURL':
          'https://firebasestorage.googleapis.com/v0/b/flutter-alert-app.appspot.com/o/profile-icon.png?alt=media&token=da62b0f2-0f43-4530-8934-db7bf423aeb5',
      'birthday': birthday,
      'tel': tel,
      'password': password,
      'admin': false,
      'postsCount': 0,
      'timestamp': DateTime.now(),
    };
  }

  //delete
  Map<String, dynamic> toDeleteMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'birthday': birthday,
      'tel': tel,
      'password': password,
      'admin': admin,
      'postsCount': postsCount,
      'timestamp': timestamp,
    };
  }

  //update
  Map<String, dynamic> toUpdateMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'birthday': birthday,
      'tel': tel,
      'password': password,
      'admin': admin,
      'postsCount': postsCount,
      'timestamp': timestamp,
    };
  }

  //search
  Map<String, dynamic> toSearchMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'birthday': birthday,
      'tel': tel,
      'password': password,
      'admin': admin,
      'postsCount': postsCount,
      'timestamp': timestamp,
    };
  }
}
