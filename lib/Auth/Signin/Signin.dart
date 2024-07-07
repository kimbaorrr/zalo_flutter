import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_myapp/Auth/CountryCode.dart';
import 'package:flutter_myapp/Auth/CountryModel.dart';
import 'package:flutter_myapp/Auth/Service/auth_service.dart';
import 'package:flutter_myapp/Auth/Service/constant.dart';
import 'package:flutter_myapp/Auth/Service/database.dart';
import 'package:flutter_myapp/Auth/Service/helper_function.dart';
import 'package:flutter_myapp/Auth/StartPage.dart';
import 'package:flutter_myapp/Auth/modals/user.dart';
import 'package:flutter_myapp/home_screen/home_screen.dart';
import 'package:flutter_myapp/widgets/custom_loading.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  String countryName = "VN";
  String countryCode = "+84";
  bool obscure = true;

  final AuthService _authService = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool circular = false;

  void signIn() {
    _authService.signInWithEmailAndPassword(
        _phoneController.text + "@gmail.com", _pwdController.text);
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    Constants.myEmail = (await HelperFunctions.getUserEmailSharedPreference())!;
  }

  // lấy danh sách tất cả user
  Future<List<Users>> getAllUser() async {
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
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StartPage()),
              );
            },
            color: Colors.white,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        title: const Text('Đăng nhập'),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(
                  width: 25,
                ),
                countryCard(),
                number(),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  width: 25,
                ),
                password(),
              ],
            ),
            if (authService.errorMessage != '')
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    authService.errorMessage,
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            const SizedBox(
              height: 25,
            ),
            const Center(
              child: Text(
                "Lấy lại mật khẩu",
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 15,
                  // fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Center(
                    child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => const DialogLoading(),
                    );
                    if (_phoneController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Thông báo"),
                            content: const Text("Vui lòng nhập số điện thoại"),
                            actions: [
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else if (_phoneController.text.length < 9 ||
                        _phoneController.text.length > 11) {
                      showMyDialog2();
                    } else {
                      await databaseMethods
                          .getUserByUserEmail(
                              "${_phoneController.text}@gmail.com")
                          .then((val) {
                        String username = '';
                        String email = '';
                        for (var element in val.docs) {
                          username = element["name"];
                          email = element["email"].replaceAll("@gmail.com", '');
                          Constants.myName = username;
                          Constants.myEmail = email;
                          print("username:" + Constants.myName);
                          print("email:" + Constants.myEmail);
                        }
                        HelperFunctions.saveUserNameSharedPreference(username);
                        HelperFunctions.saveUserEmailSharedPreference(email);
                        getUserInfo();
                        getAllUser();
                        print('đăng nhập');
                      });
                      await authService
                          .signInWithEmailAndPassword(
                              _phoneController.text + "@gmail.com",
                              _pwdController.text)
                          .then((val) {
                        Navigator.pop(context);
                        if (val != null) {
                          HelperFunctions.saveUserLoggedInSharedPreference(
                              true);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ));
                        }
                      });
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    child: Text(
                      "Đăng nhập",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ))),
          ],
        ),
      ),
    );
  }

  Widget countryCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => CountryCode(
                      setCountryData: setCountryData,
                    )));
      },
      child: Container(
        height: 50,
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Colors.blue,
          width: 1.8,
        ))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Center(
                  child: Text(
                countryCode,
                style: const TextStyle(
                  fontSize: 20,
                ),
              )),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void obscurePassword() {
    setState(() {
      obscure = !obscure;
    });
  }

  Widget number() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Colors.blue,
          width: 1.8,
        ),
      )),
      child: TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Nhập số điện thoại',
          hintStyle: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget password() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 50,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Colors.blue,
          width: 1.8,
        ),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextFormField(
              controller: _pwdController,
              obscureText: obscure,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Mật khẩu',
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: obscurePassword,
            child: Text(
              obscure ? "Hiện" : "Ẩn",
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  void setCountryData(CountryModel countryModel) {
    setState(() {
      countryName = countryModel.name;
      countryCode = countryModel.code;
    });
    Navigator.pop(context);
  }

  Future<void> showMyDialog2() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: const [
                Text("Số điện thoại không hợp lệ!",
                    style: TextStyle(fontSize: 14, color: Colors.red)),
                Text("Vui lòng nhập lại!",
                    style: TextStyle(fontSize: 14, color: Colors.red))
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                )),
          ],
        );
      },
    );
  }
}
