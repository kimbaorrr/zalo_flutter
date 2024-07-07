import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_myapp/Auth/CountryCode.dart';
import 'package:flutter_myapp/Auth/CountryModel.dart';
import 'package:flutter_myapp/Auth/Service/database.dart';
import 'package:flutter_myapp/Auth/SignUp/OTPScreen.dart';
import 'package:flutter_myapp/widgets/custom_loading.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  String countryName = "VN";
  String countryCode = "+84";
  TextEditingController _controller = TextEditingController();
  DatabaseMethods dataMethods = DatabaseMethods();
  bool circular = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text('Tạo tài khoản'),
      ),
      body: Container(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Container(
                color: Colors.grey[100],
                height: 30,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    "Nhập số điện thoại để tạo tài khoản mới",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  countryCard(),
                  number(),
                ],
              ),
              Expanded(child: Container()),
              InkWell(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => DialogLoading(),
                  );
                  FocusScope.of(context).unfocus();
                  if (_controller.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Thông báo"),
                          content: Text("Vui lòng nhập số điện thoại"),
                          actions: [
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (_controller.text.length < 9 ||
                      _controller.text.length > 11) {
                    Navigator.pop(context);
                    showMyDialog2();
                  } else {
                    await dataMethods
                        .getUserByUserEmail("${_controller.text}@gmail.com")
                        .then((val) {
                      if (val.docs.length != 0) {
                        Navigator.pop(context);
                        showMyDialog3();
                      } else
                        showMyDialog1();
                    });
                  }
                },
                child: Container(
                  color: Color(0xFF0288D1),
                  height: 40,
                  child: Center(
                    child: Text(
                      "Tiếp tục",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
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
        // width: MediaQuery.of(context).size.width / 1.1,
        width: 80,
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
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
                style: TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
                ),
              )),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            Container(
              // width: MediaQuery.of(context).size.width - 150,
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

  Widget number() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 1.5,
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Colors.blue,
          width: 1.8,
        ),
      )),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        decoration: InputDecoration(
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

  void setCountryData(CountryModel countryModel) {
    setState(() {
      countryName = countryModel.name;
      countryCode = countryModel.code;
    });
    Navigator.pop(context);
  }

  Future<void> showMyDialog1() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Xác nhận số điện thoại " + countryCode,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _controller.text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Mã xác thực sẽ gửi tới số điện thoại này",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Từ chối",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => OTPScreen(
                                countryCode: countryCode,
                                number: _controller.text,
                              )));
                },
                child: Text(
                  "Đồng ý",
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                )),
          ],
        );
      },
    );
  }

  Future<void> showMyDialog2() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text("Số điện thoại không hợp lệ",
                    style: TextStyle(fontSize: 14, color: Colors.red)),
                Text("Vui lòng thử lại!",
                    style: TextStyle(fontSize: 14, color: Colors.red))
              ],
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Đồng ý",
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  )),
            ),
          ],
        );
      },
    );
  }

  Future<void> showMyDialog3() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Số điện thoại này đã được đăng ký!",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Vui lòng đăng nhập hoặc thử lại với số điện thoại khác!",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Đồng ý",
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  )),
            ),
          ],
        );
      },
    );
  }
}
