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

  double dolar = 0.0, euro = 0.0;

  void _realChanged(String text) {
    print(text);
  }

  void _dolarChanged(String text) {
    print(text);
  }

  void _euroChanged(String text) {
    print(text);
  }

  void _bitcoinChanged(String text) {
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
    keyboardType: TextInputType.number,
  );
}
