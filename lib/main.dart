import 'package:flutter/material.dart';
import 'package:projeto/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

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
