import 'package:flutter/material.dart';
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
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Chọn mã khu vực',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: countries.length,
        itemBuilder: (context, index) => countryCard(countries[index]),
      ),
    );
  }

  Widget countryCard(CountryModel country) {
    return InkWell(
      onTap: () {
        widget.setCountryData(country);
      },
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
