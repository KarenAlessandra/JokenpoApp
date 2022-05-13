import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto/botao_jogar.dart';
import 'package:projeto/login_page.dart';

import 'jokenpo_page.dart';
import 'online.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(34, 37, 76, 1),
    );
    return Scaffold(
      backgroundColor: const Color.fromRGBO(237, 237, 237, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Entre garras e presas: Jokenpô',
            style: GoogleFonts.bebasNeue(
              fontStyle: FontStyle.italic,
              fontSize: 37.0,
              textStyle: style,
              color: Color.fromRGBO(244, 123, 143, 1),
            ),
          ),
          Image.asset(
            'imagens/cat_sit.gif',
            alignment: Alignment.center,
          ),
          const Padding(
            padding: EdgeInsets.all(10),
          ),
          BotaoJogar(
              title: 'Jogar - Sozinho',
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JokenpoPage()),
                );
              }),
//          BotaoJogar(title: 'Jogar - Duas Pessoas', action: () {}),
          BotaoJogar(
              title: 'Jogar - Online',
              action: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              }),
        ],
      ),
    );
  }
}
