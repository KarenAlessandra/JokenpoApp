import 'package:flutter/material.dart';
import 'package:projeto/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Jokenpô Game',
      debugShowCheckedModeBanner: false,
      //theme: ThemeData(backgroundColor: const Color.fromRGBO(249, 190, 125, 1)),
      home: HomePage(),
    );
  }
}
