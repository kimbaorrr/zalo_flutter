import 'package:flutter/material.dart';
import 'package:flutter_myapp/Auth/CountryModel.dart';

// import 'SignUpPage.dart';

class CountryCode extends StatefulWidget {
  const CountryCode({Key? key, required this.setCountryData}) : super(key: key);
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
        ),
        title: const Text('Chon ma khu vuc'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: ListView.builder(
          itemCount: countries.length,
          itemBuilder: (context, index) => card(countries[index])),
    );
  }

  Widget card(CountryModel country) {
    return InkWell(
      onTap: () {
        widget.setCountryData(country);
      },
      child: Card(
          margin: const EdgeInsets.all(0.15),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Text(country.name),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    country.code,
                    style: const TextStyle(fontSize: 15),
                  ),
                ))
              ],
            ),
          )),
    );
  }
}
