import 'package:flutter/material.dart';
import 'package:projeto/services/auth_service.dart';
import 'package:projeto/pages/home_page.dart';
import 'package:projeto/pages/online_page.dart';
import 'package:provider/provider.dart';

import '../pages/login_page.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading)
      return loading();
    else if (auth.usuario == null) {
      return const LoginPage();
    } else {
      return const Online();
    }
  }

  loading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
