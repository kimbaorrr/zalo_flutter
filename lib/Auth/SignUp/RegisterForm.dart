import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_myapp/Auth/Service/auth_service.dart';
import 'package:flutter_myapp/Auth/Service/database.dart';
import 'package:flutter_myapp/Auth/Signin/Signin.dart';

class RegisterForm extends StatefulWidget {
  final String number;
  const RegisterForm({Key? key, required this.number}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String gender = '1';
  TextEditingController name = TextEditingController();
  late DateTime date;
  TextEditingController dateController = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPw = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();
  DatabaseMethods _databaseMethods = DatabaseMethods();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Đăng Ký', style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    labelText: 'Nhập tên muốn hiển thị',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value as TextEditingController;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Giới tính',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: '1',
                      groupValue: gender,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          gender = '1';
                        });
                      },
                    ),
                    Text('Nam'),
                    Radio(
                      value: '0',
                      groupValue: gender,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          gender = '0';
                        });
                      },
                    ),
                    Text('Nữ'),
                  ],
                ),
                TextFormField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(hintText: 'Ngày sinh'),
                  onTap: () async {
                    var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        helpText: 'Chọn ngày sinh',
                        cancelText: 'Hủy',
                        confirmText: 'Xác nhận',
                        errorInvalidText: 'Không đúng',
                        errorFormatText: 'Không đúng định dạng',
                        firstDate: DateTime(1900),
                        lastDate: DateTime(DateTime.now().year + 1));
                    if (date != null && date != DateTime.now())
                      dateController.text =
                          DateFormat('dd/MM/yyyy').format(date);
                  },
                  onSaved: (value) {
                    date = DateFormat('dd/MM/yyyy').parse(value!);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập ngày sinh';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: confirmPw,
                  decoration: InputDecoration(
                    labelText: 'Nhập lại mật khẩu',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập lại mật khẩu';
                    }
                    if (confirmPw.text != password.text) {
                      return 'Mật khẩu không trùng khớp';
                    }
                  },
                  onSaved: (value) {
                    confirmPw = value as TextEditingController;
                  },
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 40),
                      child: Text('Đăng ký',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ),
                    onPressed: () {
                      sigUp();
                    },
                  ),
                ),
                //register
              ],
            ),
          ),
        )));
  }

  Future<void> sigUp() async {
    if (_formKey.currentState!.validate()) {
      postDetailsToFireStore();
    } else {
      Fluttertoast.showToast(msg: "Đăng ký thất bại! Vui lòng thử lại!");
    }
  }

  postDetailsToFireStore() async {
    _authService
        .createUserWithEmailAndPassword(
            "${widget.number}@gmail.com", password.text)
        .then((val) {
      Map<String, String> userInfoMap = {
        "name": name.text,
        "email": "${widget.number}@gmail.com",
        "gender": gender,
        "birthDay": dateController.text
      };
      _databaseMethods.uploadUserInfo(userInfoMap);
      Fluttertoast.showToast(
          msg:
              "Bạn đã đăng ký thành công! Vui lòng đăng nhập để trò chuyện cùng bạn bè!");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => SignInPage()),
          (route) => false);
    });
  }
}
