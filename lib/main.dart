import 'package:flutter/material.dart';
import 'package:projeto/pages/home_page.dart';
import 'package:projeto/widgets/leaderboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart';
import 'dart:ffi';
import 'firebase_options.dart';
import 'widgets/leaderboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        )
      ],
      child: const MyApp(),
    ),
  );
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
