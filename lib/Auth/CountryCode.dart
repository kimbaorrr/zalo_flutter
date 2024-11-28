import 'package:flutter/material.dart';
import 'package:zalo/Auth/Signin/Signin.dart';
import 'package:zalo/widgets/common_widget.dart';
import 'CountryModel.dart';

class CountryCode extends StatefulWidget {
  const CountryCode({super.key, required this.setCountryData});
  final Function setCountryData;

  @override
  _CountryCodeState createState() => _CountryCodeState();
}

class _CountryCodeState extends State<CountryCode> {
  List<CountryModel> countries = [
    CountryModel(name: 'Afghanistan', code: '+93'),
    CountryModel(name: 'Albania', code: '+355'),
    CountryModel(name: 'Algeria', code: '+213'),
    CountryModel(name: 'China', code: '+86'),
    CountryModel(name: 'Egypt', code: '+20'),
    CountryModel(name: 'India', code: '+91'),
    CountryModel(name: 'Singapore', code: '+65'),
    CountryModel(name: 'Thailand', code: '+66'),
    CountryModel(name: 'Vietnam', code: '+84'),
    CountryModel(name: 'United States', code: '+1'),
    CountryModel(name: 'United Kingdom', code: '+44'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Chọn mã khu vực", const SignInPage()),
      body: ListView.builder(
        itemCount: countries.length,
        itemBuilder: (context, index) => countryCard(countries[index]),
      ),
    );
  }

  Widget countryCard(CountryModel country) {
    return ElevatedButton(
      onPressed: () {
        widget.setCountryData(country);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        textStyle: const TextStyle(color: Colors.black54),
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          country.name,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Text(
          country.code,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
