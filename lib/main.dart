import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const requestUrl =
    'https://economia.awesomeapi.com.br/last/USD-BRL,EUR-BRL,BTC-BRL';

Future<void> main() async {
  http.Response response = await http.get(Uri.parse(requestUrl));

  //transformando em mapa
  print(json.decode(response.body)["USDBRL"]['bid']);
  print(json.decode(response.body)["EURBRL"]);
  print(json.decode(response.body)["BTCBRL"]);

  runApp(MaterialApp(
    home: Container(),
  ));
}
