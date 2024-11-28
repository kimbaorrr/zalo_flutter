import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zalo/Auth/StartPage.dart';
import 'package:zalo/widgets/common_widget.dart';
import 'package:zalo/widgets/custom_alert_dialog.dart';
import '/Auth/CountryCode.dart';
import '../CountryModel.dart';
import '/Auth/Service/database.dart';
import '/Auth/SignUp/OTPScreen.dart';
import '/widgets/custom_loading.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String countryName = "VN";
  String countryCode = "+84";
  final TextEditingController _phoneController = TextEditingController();
  DatabaseMethods dataMethods = DatabaseMethods();
  bool circular = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Tạo tài khoản", const StartPage()),
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
                ],
              ),
            ),
          ),
          Column(
            children: [
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: _buildCreateButton())
            ],
          )
        ],
      ),
    );
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
            builder: (builder) => CountryCode(setCountryData: setCountryData),
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

  Widget _buildCreateButton() {
    return ElevatedButton(
      onPressed: () {
        _createAccount();
      },
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors.blue,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      child: const Text(
        'Tạo tài khoản',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Future<void> _createAccount() async {
    showDialog(
      context: context,
      builder: (context) => const DialogLoading(),
    );
    FocusScope.of(context).unfocus();
    if (_phoneController.text.isEmpty) {
      showAlertDialog(context, false, "Vui lòng nhập số điện thoại");
    } else if (_phoneController.text.length < 9 ||
        _phoneController.text.length > 11) {
      Navigator.pop(context);
      showAlertDialog(context, false, "Số điện thoại không hợp lệ");
    } else {
      await dataMethods
          .getUserByUserEmail("${_phoneController.text}@gmail.com")
          .then((val) {
        Navigator.pop(context);
        if (val.docs.isNotEmpty) {
          showAlertDialog(context, false, "Số điện thoại này đã được đăng ký!");
        } else {
          showConfirmDialog();
        }
      });
    }
  }

  Future<void> showConfirmDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Xác nhận số điện thoại $countryCode ${_phoneController.text}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Mã xác thực sẽ gửi tới số điện thoại này !",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Từ chối",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => OTPScreen(
                    countryCode: countryCode,
                    number: _phoneController.text,
                  ),
                ),
              );
            },
            child: const Text(
              "Đồng ý",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
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
}
