import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'networking.dart';
import 'package:flutter_config/flutter_config.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  var selectedCurrency = 'USD';
  List<String> price = ['0', '0', '0', '0'];
  @override
  void initState() {
    bitServe();

    super.initState();
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> d = [];
    for (String currency in currenciesList) {
      var dp = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      d.add(dp);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: d,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          bitServe();
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> d = [];
    for (String currency in currenciesList) {
      var dp = Text(currency);
      d.add(dp);
    }
    return CupertinoPicker(
      children: d,
      backgroundColor: Colors.blue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        setState(() {
          bitServe();
        });
      },
    );
  }

  List<Padding> generateCard() {
    List<Padding> cry = [];
    for (int i = 0; i < price.length; i++) {
      String crypto = cryptoList[i];
      var pop = Padding(
        padding: EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $crypto = ${price[i]} $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
      cry.add(pop);
    }
    return cry;
  }

  Future bitServe() async {
    for (int i = 0; i < price.length; i++) {
      String crypto = cryptoList[i];
      NetworkHelp n = NetworkHelp(
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency?apikey=${FlutterConfig.get('FABRIC_ID')}');
      var cryptoData = await n.getData();
      setState(() {
        double p = cryptoData['rate'];

        price[i] = p.toStringAsFixed(4);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: generateCard()),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                  height: 150.0,
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 30.0),
                  color: Colors.lightBlue,
                  child: Platform.isIOS ? iosPicker() : androidDropdown()),
            ),
          )
        ],
      ),
    );
  }
}
