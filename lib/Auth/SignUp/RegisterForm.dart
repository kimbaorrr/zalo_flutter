import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zalo/widgets/custom_alert_dialog.dart';
import '/Auth/Service/auth_service.dart';
import '/Auth/Service/database.dart';
import '/Auth/Signin/Signin.dart';

class RegisterForm extends StatefulWidget {
  final String number;
  const RegisterForm({super.key, required this.number});

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
  final AuthService _authService = AuthService();
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Đăng ký',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    labelText: 'Nhập tên muốn hiển thị',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
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
                const SizedBox(height: 16),
                const Text(
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
                    const Text('Nam'),
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
                    const Text('Nữ'),
                  ],
                ),
                TextFormField(
                  readOnly: true,
                  controller: dateController,
                  decoration: const InputDecoration(
                    hintText: 'Ngày sinh',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
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
                    if (date != null && date != DateTime.now()) {
                      dateController.text =
                          DateFormat('dd/MM/yyyy').format(date);
                    }
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: password,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPw,
                  decoration: const InputDecoration(
                    labelText: 'Nhập lại mật khẩu',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập lại mật khẩu';
                    }
                    if (confirmPw.text != password.text) {
                      return 'Mật khẩu không trùng khớp';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    confirmPw = value as TextEditingController;
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      signUp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      child: Text('Đăng ký',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      postDetailsToFireStore();
      showAlertDialog(context, true, "Đăng kí tài khoản thành công !");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => const SignInPage()),
          (route) => false);
    } else {
      showAlertDialog(context, false, "Đăng kí thất bại. Thử lại !");
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
        "birthDay": dateController.text,
        "avatar":
            "https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg"
      };
      _databaseMethods.uploadUserInfo(userInfoMap);
    });
  }
}
