import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/Auth/modals/user.dart';
import '/Auth/CountryCode.dart';
import '/Auth/CountryModel.dart';
import '/Auth/Service/auth_service.dart';
import '/Auth/Service/database.dart';
import '/Auth/Service/helper_function.dart';
import '/Auth/StartPage.dart';
import '/home_screen/home_screen.dart';
import '/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import '/Auth/Service/constant.dart';
import '/widgets/custom_alert_dialog.dart';
import '/widgets/common_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String countryName = "VN";
  String countryCode = "+84";
  bool obscure = true;
  bool isAgreed = false;

  final AuthService _authService = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool circular = false;

  void signIn() {
    _authService.signInWithEmailAndPassword(
        "${_phoneController.text}@gmail.com", _pwdController.text);
  }

  Future<List<Users>> _getAllUser() async {
    listUsers.clear();
    return await FirebaseFirestore.instance
        .collection("Users")
        .get()
        .then((users) {
      for (final DocumentSnapshot<Map<String, dynamic>> doc in users.docs) {
        listUsers.add(Users.fromDocumentSnapshot(doc: doc));
        listUsers.removeWhere((element) =>
            element.email.replaceAll("@gmail.com", '') == Constants.myEmail);
      }
      return listUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
        appBar: buildAppBar(context, "Đăng nhập", const StartPage()),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildPhoneNumberInput(),
                    const SizedBox(height: 20),
                    _buildPasswordInput(),
                    if (authService.errorMessage != '')
                      _buildInputMessage(authService.errorMessage),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [_buildResetPassword()],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAgreePolicy(),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: _buildNextButton());
  }

  Widget _buildPhoneNumberInput() {
    return Stack(
      children: [
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
          ],
          decoration: const InputDecoration(
            hintText: 'Nhập số điện thoại',
            hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.only(left: 60),
          ),
        ),
        Positioned(
          left: 0,
          child: _buildCountryCodeSelector(),
        ),
      ],
    );
  }

  Widget _buildCountryCodeSelector() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => CountryCode(setCountryData: _setCountryData),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              countryCode,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        Expanded(
          child: TextFormField(
            controller: _pwdController,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: 'Mật khẩu',
              hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: _obscurePassword,
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildInputMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildResetPassword() {
    return const Text(
      "Lấy lại mật khẩu",
      style: TextStyle(
          color: Colors.lightBlue, fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildAgreePolicy() {
    return Row(
      children: [
        Checkbox(
          value: isAgreed,
          onChanged: (value) {
            setState(() {
              isAgreed = value ?? false;
            });
          },
          activeColor: Colors.blue,
        ),
        const Expanded(
          child: Text(
            'Tôi đã đồng ý với các điều khoản và chính sách.',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (!isAgreed) {
          showAlertDialog(
            context,
            false,
            "Vui lòng đồng ý với các điều khoản để tiếp tục.",
          );
          return;
        } else if (_phoneController.text.isEmpty ||
            _pwdController.text.isEmpty) {
          showAlertDialog(context, false, "Vui lòng điền đầy đủ thông tin.");
        } else {
          await _loginUser();
        }
      },
      backgroundColor: Colors.blue,
      child: const Icon(Icons.arrow_forward, color: Colors.white),
    );
  }

  void _setCountryData(CountryModel countryModel) {
    setState(() {
      countryName = countryModel.name;
      countryCode = countryModel.code;
    });
    Navigator.pop(context);
  }

  void _obscurePassword() {
    setState(() {
      obscure = !obscure;
    });
  }

  Future<dynamic> _loginUser() async {
    showDialog(
      context: context,
      builder: (context) => const DialogLoading(),
    );

    await databaseMethods
        .getUserByUserEmail("${_phoneController.text}@gmail.com")
        .then((val) {
      String username = '';
      String email = '';
      String avatar = '';
      for (var element in val.docs) {
        username = element["name"];
        email = element["email"].replaceAll("@gmail.com", '');
        avatar = element["avatar"];
        Constants.myName = username;
        Constants.myEmail = email;
        Constants.myAvatar = avatar;
      }
      HelperFunctions.saveUserNameSharedPreference(username);
      HelperFunctions.saveUserEmailSharedPreference(email);
      HelperFunctions.saveUserAvatarSharedPreference(avatar);
      _authService
          .signInWithEmailAndPassword(
              "${_phoneController.text}@gmail.com", _pwdController.text)
          .then((val) {
        Navigator.pop(context);
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          showAlertDialog(
              context, false, "Số điện thoại hoặc mật khẩu không đúng !");
        }
      });
    });
  }
}
