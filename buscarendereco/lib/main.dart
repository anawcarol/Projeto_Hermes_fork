import 'package:flutter/material.dart';
import 'package:buscareferencia/screens/busca_endereco_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busca Referência',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchAddressScreen(), // Definindo a tela de busca como a inicial
    );
  }
}
