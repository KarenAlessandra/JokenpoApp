import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto/widgets/botao_jogar.dart';
import 'package:projeto/pages/login_page.dart';
import 'package:screenshot/screenshot.dart';
import 'jokenpo_page.dart';
import 'online_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final controller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(34, 37, 76, 1),
    );
    return Screenshot(
        controller: controller,
        child: Scaffold(
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
                      MaterialPageRoute(builder: (context) => JokenpoPage()),
                    );
                  }),
//          BotaoJogar(title: 'Jogar - Duas Pessoas', action: () {}),
              BotaoJogar(
                  title: 'Jogar - Online',
                  action: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  }),
            ],
          ),
        ));
  }
}
