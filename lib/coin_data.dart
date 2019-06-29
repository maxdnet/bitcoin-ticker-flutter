import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

const apiUrl = 'https://apiv2.bitcoinaverage.com/indices/global/ticker/';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  String crypto;
  String conversionValue;

  CoinData({this.crypto, this.conversionValue});
}

class CoinHelper {
  List<CoinData> coinDataList = [];

  List<DropdownMenuItem> getDropDownCoinList() {
    List<DropdownMenuItem<String>> currencyList = [];

    for (String item in currenciesList) {
      currencyList.add(DropdownMenuItem(
        child: Text(item),
        value: item,
      ));
    }
    return currencyList;
  }

  List<Text> getCupertinoCoinList() {
    List<Text> currencyList = [];

    for (String item in currenciesList) {
      currencyList.add(Text(item));
    }
    return currencyList;
  }

  List<Widget> getCryptoPadding(String exchangeTitle) {
    List<Widget> widgetList = [];

    for (var item in coinDataList) {
      widgetList.add(Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.black87,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: _getCryptoText(item, exchangeTitle),
          ),
        ),
      ));
    }

    return widgetList;
  }

  Text _getCryptoText(CoinData item, String exchangeTitle) {
    return Text('1 ${item.crypto} = ${item.conversionValue} $exchangeTitle',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.amber,
        ));
  }

  CoinHelper() {
    for (String crypto in cryptoList) {
      coinDataList.add(CoinData(crypto: crypto, conversionValue: '?'));
    }
  }
}

class CoinNetwork {
  Future<double> getCoinConversionValue(String coins) async {
    var ret = 0.0;
    var url = apiUrl + coins;

    var client = http.Client();
    try {
      var response = await client.get(url).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        ret = jsonResponse["last"];
      } else {
        //print("Request failed with status: ${response.statusCode}.");
        ret = -1;
      }
    } catch (e) {
      //print(e.toString());
      ret = -1;
    } finally {
      client.close();
    }
    return ret;
  }
}
