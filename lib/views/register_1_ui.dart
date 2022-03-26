import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_alert/net/flutterfire.dart';
import 'package:flutter_app_alert/views/login_ui.dart';

class Register1UI extends StatefulWidget {
  const Register1UI({Key? key}) : super(key: key);

  @override
  _Register1UIState createState() => _Register1UIState();
}

class _Register1UIState extends State<Register1UI> {
  TextEditingController _email = TextEditingController();
  TextEditingController _name = TextEditingController();
  // TextEditingController _birtDate = TextEditingController();
  TextEditingController _tel = TextEditingController();
  TextEditingController _password = TextEditingController();
  final auth = FirebaseAuth.instance;
  AuthClass authClass = AuthClass();

  //hide password
  bool _isObscure = true;
//
  DateTime date = DateTime(2022, 12, 24);
//

  // final _formKey = GlobalKey<FormState>();
  // String? name, email, birthDate, tel, password;
  // var name = '';
  // var email = '';
  // var password = '';
  // var birthDate = '';
  // var tel = '';
  //
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
        backgroundColor: Colors.grey[50],
        body: SingleChildScrollView(
          child: Center(
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
                      child: TextField(
                        //onsave
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        decoration: InputDecoration(
                          labelText: 'อีเมล  ',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Form(
                //   key: _formKey,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: <Widget>[
                //       TextFormField(
                //         decoration: const InputDecoration(
                //           icon: Icon(Icons.person),
                //           hintText: 'ชื่อ',
                //           labelText: 'ชื่อ',
                //         ),
                //         onChanged: (value) {
                //           _name = value as TextEditingController;
                //         },
                //         validator: (value) {
                //           if (value == null || value.isEmpty) {
                //             return 'กรุณากรอกชื่อ';
                //           }
                //           return null;
                //         },
                //       ),
                //       TextFormField(
                //         decoration: const InputDecoration(
                //           icon: Icon(Icons.email),
                //           hintText: 'อีเมล',
                //           labelText: 'อีเมล',
                //         ),
                //         onChanged: (value) {
                //           _email = value as TextEditingController;
                //         },
                //         validator: (value) {
                //           if (value == null || value.isEmpty) {
                //             return 'กรุณากรอกอีเมล';
                //           }
                //           return null;
                //         },
                //       ),
                //     ],
                //   ),
                // ),
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
                        //onsave
                        keyboardType: TextInputType.emailAddress,
                        controller: _name,
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
                      '${date.year}/${date.month}/${date.day}',
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
                      child: TextField(
                        keyboardType: TextInputType.number,
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
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                //feid field for password
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        obscureText: _isObscure,
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: 'รหัสผ่าน  ',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
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
                  onPressed: () async {
                    print('####################################');
                    bool shouldNavigate =
                        await register(_email.text, _password.text);
                    // if (_formKey.currentState!()) {
                    //   _formKey.currentState?.save();
                    //   print(
                    //       'email : $_email , password : $_password , name : $_name');
                    // }
                    if (shouldNavigate) {
                      users
                          .add({
                            'name': _name.text,
                            'email': _email.text,
                            'tel': _tel.text,
                            'password': _password.text,
                            'birthday':
                                '${date.year}/${date.month}/${date.day}',
                          })
                          .then((value) => print('User.added'))
                          .catchError(
                              (error) => print('Failed to add user: $error'));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginUI(),
                        ),
                      );
                    }
                  },
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

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'มีบัญชีแล้วใช่หรือไม่?   ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginUI(),
                          ),
                        );
                      },
                      child: Text(
                        'ล็อคอินที่นี่',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                //google login button
              ],
            ),
          ),
        ),
      ),
    );
  }
}
