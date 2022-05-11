import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();

  bool isLogin = true;
  late String titulo = '';
  late String actionButton = '';
  late String toggleButton = '';

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = 'Bem vindo';
        actionButton = 'Login';
        toggleButton = 'É necessário estar logado para jogar online.';
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao login.';
      }
    });
  }

  login() async {
    try {
      await context.read<AuthService>().login(email.text, senha.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  registrar() async {
    try {
      await context.read<AuthService>().registrar(email.text, senha.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromRGBO(161, 220, 216, 1)),
      backgroundColor: const Color.fromRGBO(237, 237, 237, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 60),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titulo,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Color.fromRGBO(244, 123, 143, 1),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o email corretamente!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: TextFormField(
                    controller: senha,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe sua senha!';
                      } else if (value.length < 8) {
                        return 'Sua senha deve ter no mínimo 8 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Color.fromRGBO(161, 220, 216, 1)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (isLogin) {
                          login();
                        } else {
                          registrar();
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check,
                          color: Color.fromRGBO(244, 123, 143, 1),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            actionButton,
                            style: GoogleFonts.bebasNeue(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: Color.fromRGBO(244, 123, 143, 1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        textStyle: TextStyle(
                            decorationColor: Color.fromRGBO(244, 123, 143, 1),
                            color: Color.fromRGBO(244, 123, 143, 1),
                            fontSize: 15,
                            letterSpacing: 0)),
                    onPressed: () => setFormAction(!isLogin),
                    child: Text(toggleButton)),
                Image.asset(
                  'imagens/cat_loaf.gif',
                  alignment: Alignment.center,
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
