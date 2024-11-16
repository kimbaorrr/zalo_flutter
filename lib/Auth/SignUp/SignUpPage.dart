import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zalo/widgets/custom_alert_dialog.dart';
import '/Auth/CountryCode.dart';
import '../CountryModel.dart';
import '/Auth/Service/database.dart';
import '/Auth/SignUp/OTPScreen.dart';
import '/widgets/custom_loading.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String countryName = "VN";
  String countryCode = "+84";
  final TextEditingController _controller = TextEditingController();
  DatabaseMethods dataMethods = DatabaseMethods();
  bool circular = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Tạo tài khoản',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nhập số điện thoại để tạo tài khoản mới",
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                countryCard(),
                const SizedBox(width: 12),
                Expanded(child: number()),
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: _onContinueTap,
              child: Container(
                color: const Color(0xFF0084FF),
                height: 48,
                child: const Center(
                  child: Text(
                    "Tiếp tục",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
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
            ),
          ),
        );
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.blue.shade700, width: 1.5)),
        ),
        child: Row(
          children: [
            Text(
              countryCode,
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  Widget number() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
        decoration: const InputDecoration(
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
          hintText: 'Nhập số điện thoại',
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Future<void> _onContinueTap() async {
    showDialog(
      context: context,
      builder: (context) => const DialogLoading(),
    );
    FocusScope.of(context).unfocus();
    if (_controller.text.isEmpty) {
      showAlertDialog(context, false, "Vui lòng nhập số điện thoại");
    } else if (_controller.text.length < 9 || _controller.text.length > 11) {
      Navigator.pop(context);
      showAlertDialog(context, false, "Số điện thoại không hợp lệ");
    } else {
      await dataMethods
          .getUserByUserEmail("${_controller.text}@gmail.com")
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Xác nhận số điện thoại $countryCode ${_controller.text}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Mã xác thực sẽ gửi tới số điện thoại này",
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
                    number: _controller.text,
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
