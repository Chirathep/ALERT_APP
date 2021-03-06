import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_alert/net/flutterfire.dart';
import 'package:flutter_app_alert/net/user_model.dart';
import 'package:flutter_app_alert/views/main/main_home_ui.dart';

class Register2UI extends StatefulWidget {
  const Register2UI({Key? key}) : super(key: key);

  @override
  State<Register2UI> createState() => _Register2UIState();
}

class _Register2UIState extends State<Register2UI> {
  bool isButtonActive = true;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _tel = TextEditingController();

  String? name;
  String? tel;
  DateTime date = DateTime(2022, 12, 24);
  final auth = FirebaseAuth.instance;
  AuthClass authClass = AuthClass();
  var submitvalue = 0;
  final photoURLlink =
      "https://firebasestorage.googleapis.com/v0/b/flutter-alert-app.appspot.com/o/profile-icon.png?alt=media&token=da62b0f2-0f43-4530-8934-db7bf423aeb5";

  var sub1 = 0;
  var sub2 = 0;

  submit() {
    final form = _formKey.currentState;
    //if form validate true
    if (form!.validate()) {
      form.save();
      Navigator.pop(context, {'name': name, 'date': date, 'tel': tel});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Text(' '),
        centerTitle: true,
        backgroundColor: Colors.grey[50],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          //คำสั่งกลับไปหน้าก่อนหน้า
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    'สร้างบัญชีผู้ใช้',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.001,
                  ),
                  Text(
                    'กรุณากรอกข้อมูลให้ครบถ้วน',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                        ),
                        child: TextFormField(
                          onSaved: ((val) => name = val),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'กรุณากรอกชื่อ';
                            } else if (value.trim().length < 3 ||
                                value.isEmpty) {
                              return 'ชื่อต้องมีความยาวอย่างน้อย 3 ตัวอักษร';
                            } else if (value.trim().length > 20) {
                              return 'ชื่อต้องมีความยาวไม่เกิน 20 ตัวอักษร';
                            } else if (!RegExp(r'^[a-zA-Zก-๙0-9@_]*$')
                                .hasMatch(value)) {
                              return 'ชื่อต้องเป็นภาษาไทยหรือภาษาอังกฤษ';
                            } else {
                              return null;
                            }
                          },
                          controller: _name,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'ชื่อ  ',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'วันเกิด',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Text(
                        '${date.day}/${date.month}/${date.year}',
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      const SizedBox(
                        width: 0,
                      ),
                      ElevatedButton(
                        child: Text('เลือกวันเกิด'),
                        onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          //'cancel' => null
                          if (newDate == null) return;
                          //'ok => Datetime'
                          setState(() => date = newDate);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          primary: Color(0xffEC9B2F),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  //fied for email
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'กรุณากรอกเบอร์โทรศัพท์';
                            } else if (value.trim().length < 10 ||
                                value.isEmpty) {
                              return 'เบอร์โทรศัพท์ต้องมีความยาว 10 ตัวอักษร';
                            } else if (value.trim().length > 10) {
                              return 'เบอร์โทรศัพท์ต้องมีความยาวไม่เกิน 10 ตัว';
                            } else {
                              return null;
                            }
                          },
                          onSaved: ((val) => tel = val),
                          controller: _tel,
                          decoration: InputDecoration(
                            labelText: 'เบอร์โทรศัพท์',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),

                  ElevatedButton(
                    onPressed: isButtonActive
                        ? () async {
                            await submit();
                            postDetailToFirestoreGmail();
                            //Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainHomeUI()));
                          }
                        : null,
                    //Next btn
                    child: Text(
                      'ยืนยัน',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                        MediaQuery.of(context).size.width - 95,
                        50,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                      primary: Color(0xff39b54a),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  postDetailToFirestoreGmail() async {
    //call firestore
    //call userModel
    //sending values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    UserModel userModel = UserModel();
    //weritting all values
    userModel.uid = user?.uid;
    userModel.name = _name.text;
    userModel.photoURL = photoURLlink.toString();
    userModel.tel = _tel.text;
    userModel.birthday = '${date.year}/${date.month}/${date.day}';
    userModel.email = user?.email;
    //sending to firestore
    await firebaseFirestore
        .collection('users')
        .doc(user?.uid)
        .set(userModel.toMap())
        .then((value) => print('User.added'))
        .catchError((error) => print('Failed to add user: $error'));
  }
}
