import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:zalo/Auth/Signin/Signin.dart';
import 'package:zalo/widgets/common_widget.dart';
import 'package:zalo/widgets/custom_alert_dialog.dart';
import '/Auth/SignUp/RegisterForm.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.countryCode, required this.number});
  final String number;
  final String countryCode;
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  int start = 30;
  bool wait = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Nhập mã OTP", const SignInPage()),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.grey.shade100,
                width: MediaQuery.of(context).size.width,
                height: 30,
                child: const Center(
                  child: Text(
                    "Vui lòng không chia sẻ mã code tránh mất tài khoản !",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildAlertText(),
              const SizedBox(
                height: 20,
              ),
              _buildOTP(),
              const SizedBox(
                height: 20,
              ),
              _buildResendButton(),
              const Spacer(),
              _buildConfirmButton()
            ],
          )),
    );
  }

  Widget _buildResendButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      child: const Text(
        "Gửi lại mã",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => RegisterForm(
                  number: widget.number,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            textStyle: const TextStyle(color: Colors.white),
            minimumSize: const Size(double.infinity, 50),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            elevation: 0,
          ),
          child: const Text(
            "Xác nhận",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ));
  }

  Widget _buildAlertText() {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text:
                  'Đã gửi mã OTP đến số (${widget.countryCode}) ${widget.number}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          const TextSpan(
            text: '\n\n',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(
            text: 'Vui lòng điền mã xác nhận vào ô bên dưới!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ]));
  }

  Widget _buildOTP() {
    return OTPTextField(
      length: 4,
      width: MediaQuery.of(context).size.width * 0.8,
      fieldWidth: 30,
      style: const TextStyle(
        fontSize: 17,
        color: Colors.black,
      ),
      textFieldAlignment: MainAxisAlignment.center,
      fieldStyle: FieldStyle.underline,
      inputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      onCompleted: (pin) {
        showAlertDialog(
            context, true, "Bạn đã nhập mã PIN $pin khớp với hệ thống !");
      },
    );
  }
}
