import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const requestUrl =
    'https://economia.awesomeapi.com.br/last/USD-BRL,EUR-BRL,BTC-BRL';

Future<void> main() async {
  //transformando em mapa
  // print(json.decode(response.body)["USDBRL"]['bid']);
  // print(json.decode(response.body)["EURBRL"]);
  // print(json.decode(response.body)["BTCBRL"]);

  print(await getData());
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  //dado do fututro
  http.Response response = await http.get(Uri.parse(requestUrl));

  //retornando o json
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final bitcoinController = TextEditingController();

  double dolar = 0.0, euro = 0.0, bitcoin = 0.0;

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    bitcoinController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);

    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    bitcoinController.text = (real / bitcoin).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);

    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    bitcoinController.text = (dolar * this.dolar / bitcoin).toStringAsFixed(2);

    print(text);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);

    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    bitcoinController.text = (euro * this.euro / bitcoin).toStringAsFixed(2);
  }

  void _bitcoinChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double bitcoin = double.parse(text);

    realController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
    dolarController.text = (bitcoin * this.bitcoin / dolar).toStringAsFixed(2);
    euroController.text = (bitcoin * this.bitcoin / euro).toStringAsFixed(2);

    print(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "\$ Conversor de Moedas \$",
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  "Carregando Dados...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar dados :(",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = double.parse(snapshot.data?["USDBRL"]['bid']);
                euro = double.parse(snapshot.data?["EURBRL"]['bid']);
                bitcoin = double.parse(snapshot.data?["BTCBRL"]['bid']);
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 150.0, color: Colors.amber),
                      buildTextField(
                          "Reais", "R\$", realController, _realChanged),
                      Divider(
                        height: 20,
                      ),
                      buildTextField(
                          "Dólares", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField(
                          "Euros", "€", euroController, _euroChanged),
                      Divider(),
                      buildTextField("Bitcoins", "BTC", bitcoinController,
                          _bitcoinChanged),
                      Divider(),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

buildTextField(labelText, prefixText, TextEditingController controller,
    ValueChanged<String> func) {
  return TextField(
    controller: controller,
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
        ),
        prefixText: "$prefixText "),
    onChanged: func,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
