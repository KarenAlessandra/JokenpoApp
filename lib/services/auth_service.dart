// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  // FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;
  late String token;

  // AuthService() {
  //   _authCheck();
  // }

  bool authCheck() {
    return usuario != null;
    // _auth.authStateChanges().listen((User? user) {
    //   usuario = (user == null) ? null : user;
    //   isLoading = false;
    //   notifyListeners();
    // });
  }

  // _getUser() {
  //   // usuario = _auth.currentUser;
  //   notifyListeners();
  // }

  registrar(String email, String senha, String nickname) async {
    var resp = await http.post(Uri.parse('http://10.0.2.2:8080/register'),
        body: jsonEncode(
            {'email': email, 'password': senha, 'nickname': nickname}));
    // print(resp.body);
    if (resp.statusCode == 200) {
      print('registrado');
    } else {
      print('erro');
      return;
    }
    usuario = User(email, senha);
    notifyListeners();
    // try {
    //   await _auth.createUserWithEmailAndPassword(email: email, password: senha);
    //   _getUser();
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     throw AuthException('A senha é muita fraca!');
    //   } else if (e.code == 'email-already-in-use') {
    //     throw AuthException('Este email já está em uso!');
    //   }
    // }
  }

  login(String email, String senha) async {
    var resp = await http.post(Uri.parse('http://10.0.2.2:8080/login'),
        body: jsonEncode({'email': email, 'password': senha}));
    token = resp.body;
    if (token.length != 32) {
      throw AuthException('Email ou senha incorretos! ' + token);
    }
    usuario = User(email, senha);
    notifyListeners();
    // try {
    //   await _auth.signInWithEmailAndPassword(email: email, password: senha);
    //   _getUser();
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     throw AuthException('Email não encontrado. Cadastre-se agora.');
    //   } else if (e.code == 'wrong-password') {
    //     throw AuthException('Senha incorreta. Tente novamente!');
    //   }
    // }
  }

  logout() async {
    await http.post(Uri.parse('http://10.0.2.2:8080/logout'), body: token);
    token = "";
    notifyListeners();
    // await _auth.signOut();
    // _getUser();
  }
}

class User {
  String email;
  String password;
  User(this.email, this.password);
}
