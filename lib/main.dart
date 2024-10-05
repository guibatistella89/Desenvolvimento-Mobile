import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/modules/home/controller/cep_controller.dart';
import 'src/modules/home/page/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CepController(),
      child: MaterialApp(
        title: 'Desafio 1',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
