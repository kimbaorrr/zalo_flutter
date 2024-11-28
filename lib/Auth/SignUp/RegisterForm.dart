import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zalo/Auth/SignUp/SignUpPage.dart';
import 'package:zalo/widgets/common_widget.dart';
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
  TextEditingController _nameController = TextEditingController();
  late DateTime date;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _password = TextEditingController();
  TextEditingController _confirmPw = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context, "Đăng ký", const SignUpPage()),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildName(),
                const SizedBox(height: 16),
                _buildGender(),
                const SizedBox(height: 16),
                _buildDateofBirth(),
                const SizedBox(height: 16),
                _buildPassword(),
                const SizedBox(height: 16),
                _buildConfirmPwd(),
                _buildConfirmButton()
              ],
            ),
          ),
        )));
  }

  Widget _buildName() {
    return TextFormField(
      controller: _nameController,
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
        _nameController = value as TextEditingController;
      },
    );
  }

  Widget _buildGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Giới tính',
              style: TextStyle(fontSize: 16),
            ),
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
        )
      ],
    );
  }

  Widget _buildDateofBirth() {
    return TextFormField(
      readOnly: true,
      controller: _dateController,
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
          _dateController.text = DateFormat('dd/MM/yyyy').format(date);
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
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      controller: _password,
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
    );
  }

  Widget _buildConfirmPwd() {
    return TextFormField(
      controller: _confirmPw,
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
        if (_confirmPw.text != _password.text) {
          return 'Mật khẩu không trùng khớp';
        }
        return null;
      },
      onSaved: (value) {
        _confirmPw = value as TextEditingController;
      },
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ElevatedButton(
          onPressed: () {
            _signUp();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: Text('Đăng ký',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
          ),
        ));
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      _postDetailsToFireStore();
      showAlertDialog(context, true, "Đăng kí tài khoản thành công !");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => const SignInPage()),
          (route) => false);
    } else {
      showAlertDialog(context, false, "Đăng kí thất bại. Thử lại !");
    }
  }

  _postDetailsToFireStore() async {
    _authService
        .createUserWithEmailAndPassword(
            "${widget.number}@gmail.com", _password.text)
        .then((val) {
      Map<String, dynamic> userInfoMap = {
        "name": _nameController.text,
        "email": "${widget.number}@gmail.com",
        "gender": gender,
        "birthDay": _dateController.text,
        "avatar":
            "https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/avatar-trang-4.jpg",
        "friends": []
      };
      _databaseMethods.uploadUserInfo(userInfoMap);
    });
  }
}
