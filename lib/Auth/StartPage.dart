import 'package:flutter/material.dart';
import 'package:flutter_myapp/Auth/SignUp/SignUpPage.dart';
import 'package:flutter_myapp/Auth/Signin/Signin.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          height: MediaQuery.of(context).size.height + 44,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              const Text(
                'Zalo',
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(
                height: 200,
              ),
              signInButton(),
              const SizedBox(
                height: 20,
              ),
              signUpButton(),
              Expanded(flex: 2, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Tiếng Việt",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "English",
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "日本語",
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          )),
    );
  }

  Widget signUpButton() {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpPage()),
          );
        },
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFE0E0E0),
          ),
          child: const Center(
            child: Text(
              'Đăng ký',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ));
  }

  Widget signInButton() {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
          );
        },
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue,
          ),
          child: const Center(
            child: Text(
              'Đăng nhập',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
