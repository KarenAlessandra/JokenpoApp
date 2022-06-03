import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'jokenpoFight_page.dart';

class JokenpoPage extends StatelessWidget {
  const JokenpoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
        fontWeight: FontWeight.bold, color: Color.fromRGBO(244, 123, 143, 1));
    return Scaffold(
      backgroundColor: const Color.fromRGBO(237, 237, 237, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(161, 220, 216, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color.fromRGBO(161, 220, 216, 1),
                    content: Text(
                      'Instruções de jogo:\n'
                      '\n'
                      'Escolha um dos ataques: Pedra, Papel ou Tesoura.\n'
                      '- Pedra vence da Tesoura e perde do Papel.\n'
                      '- Tesoura ganha do Papel e perde da Pedra.\n'
                      '- Papel ganha da Pedra e perde da Tesoura.\n'
                      'Se os dois escolherem a mesma coisa, empatam.\n',
                      //'O objetivo é vencer o jogo.',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 20.5,
                        textStyle: style,
                        letterSpacing: 1.5,
                        color: const Color.fromRGBO(81, 174, 174, 1),
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('OK', style: style),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(245, 205, 211, 1),
                          side: const BorderSide(
                            color: Color.fromRGBO(245, 205, 211, 1),
                            width: 3,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 250),
            Text(
              "Escolha um dos ataques:",
              style: GoogleFonts.bebasNeue(
                fontSize: 30,
                textStyle: style,
                letterSpacing: 1.5,
                color: Color.fromRGBO(243, 170, 187, 1),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: const Color.fromRGBO(81, 174, 174, 1),
                      primary: const Color.fromRGBO(161, 220, 216, 1),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JokenpoFightPage("pedra")));
                    },
                    child: Text(
                      "Pedra",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 25,
                        textStyle: style,
                        letterSpacing: 1.5,
                        color: const Color.fromRGBO(244, 123, 143, 1),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: const Color.fromRGBO(81, 174, 174, 1),
                      primary: const Color.fromRGBO(161, 220, 216, 1),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JokenpoFightPage("papel")));
                    },
                    child: Text(
                      "Papel",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 25,
                        textStyle: style,
                        letterSpacing: 1.5,
                        color: const Color.fromRGBO(244, 123, 143, 1),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: const Color.fromRGBO(81, 174, 174, 1),
                      primary: const Color.fromRGBO(161, 220, 216, 1),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  JokenpoFightPage("tesoura")));
                    },
                    child: Text(
                      "Tesoura",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 25,
                        textStyle: style,
                        letterSpacing: 1.5,
                        color: const Color.fromRGBO(244, 123, 143, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 200),
              child: Image(
                  image: AssetImage('imagens/cat_fight.gif'), height: 200),
            ),
          ],
        ),
      ),
    );
  }
}
