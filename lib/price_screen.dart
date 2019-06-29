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
  CoinHelper coinHelper = CoinHelper();
  CoinNetwork coinNetwork = CoinNetwork();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoinConversionRatio('USD');
  }

  CupertinoPicker getCupertinoPicker() {
    return CupertinoPicker(
      children: coinHelper.getCupertinoCoinList(),
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedPickerIndex) {
        print(selectedPickerIndex);
      },
    );
  }

  DropdownButton<String> getAndroidPicker() {
    return DropdownButton<String>(
        value: selectedCurrency,
        items: coinHelper.getDropDownCoinList(),
        onChanged: (value) async {
          getCoinConversionRatio(value);
          setState(() {
            for (var crypto in coinHelper.coinDataList) {
              crypto.conversionValue = '?';
            }
            selectedCurrency = value;
          });
        });
  }

  void getCoinConversionRatio(String exchangeCurrency) async {
    for (var crypto in coinHelper.coinDataList) {
      var ret = await coinNetwork
          .getCoinConversionValue(crypto.crypto + exchangeCurrency);
      setState(() {
        crypto.conversionValue = (ret > -1) ? ret.toString() : 'NA';
      });
    }
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: coinHelper.getCryptoPadding(selectedCurrency),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            //color: Colors.lightBlue,
            child: Platform.isIOS ? getCupertinoPicker() : getAndroidPicker(),
          ),
        ],
      ),
    );
  }
}
