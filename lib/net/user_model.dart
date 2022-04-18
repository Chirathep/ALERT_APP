class UserModel {
  String? uid;
  String? email;
  String? name;
  String? birthday;
  String? tel;
  String? password;
  String? admin;
  String? postsCount;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.birthday,
    this.tel,
    this.password,
    this.admin,
    this.postsCount,
  });

//firestore
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      birthday: map['birthday'],
      tel: map['tel'],
      password: map['password'],
      admin: map['admin'],
      postsCount: map['postsCount'],
    );
  }

  // Object? get displayName => null;

  // sending data to firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'birthday': birthday,
      'tel': tel,
      'password': password,
      'admin': false,
      'postsCount': 0,
    };
  }
}
