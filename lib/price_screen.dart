import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  int selectedPickerIndex = 0;
  CoinData coinData = CoinData();
  CoinNetwork coinNetwork = CoinNetwork();
  String conversionRatio = '?';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoinConversionRatio('USD');
  }

  CupertinoPicker getCupertinoPicker() {
    return CupertinoPicker(
      children: coinData.getCupertinoCoinList(),
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedPickerIndex) {
        print(selectedPickerIndex);
      },
    );
  }

  DropdownButton<String> getAndroidPicker() {
    return DropdownButton<String>(
        value: selectedCurrency,
        items: coinData.getDropDownCoinList(),
        onChanged: (value) async {
          getCoinConversionRatio(value);
          setState(() {
            conversionRatio = '?';
            selectedCurrency = value;
          });
        });
  }

  void getCoinConversionRatio(String exchangeCurrency) async {
    var ret =
        await coinNetwork.getCoinConversionValue('BTC' + exchangeCurrency);
    setState(() {
      conversionRatio = (ret > -1) ? ret.toString() : 'NA';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $conversionRatio $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getCupertinoPicker() : getAndroidPicker(),
          ),
        ],
      ),
    );
  }
}
