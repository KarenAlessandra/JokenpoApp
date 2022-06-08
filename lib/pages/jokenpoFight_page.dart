import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:projeto/widgets/botao_jogar.dart';
import 'package:projeto/widgets/logica.dart';

import 'home_page.dart';
import 'jokenpo_page.dart';

class JokenpoFightPage extends StatelessWidget {
  late String escolha;
  late String pc;
  // const JokenpoFightPage({Key? key, escolha = String}) : super(key: key);
  JokenpoFightPage(escolha, {Key? key}) {
    this.escolha = escolha;
    pc = randomChoice();
  }

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(244, 123, 143, 1));
    return Scaffold(
      backgroundColor: const Color.fromRGBO(237, 237, 237, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 10)), // espaçamento
            AnimatedTextKit(
              repeatForever: false,
              isRepeatingAnimation: false,
              animatedTexts: [
                WavyAnimatedText('JO KEN PÔ!',
                    textStyle: style, speed: const Duration(milliseconds: 220)),
              ],
            ),
            //row aqui
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                choiceToImage(escolha, false),
                choiceToImage(pc, true),
              ],
            ),
            whoWon(escolha, pc),

            BotaoJogar(
                title: "Jogar novamente",
                action: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const JokenpoPage(),
                        maintainState: false),
                  );
                }),
            BotaoJogar(
                title: "Voltar ao Menu",
                action: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                }),

            Padding(padding: EdgeInsets.all(0.0)), // espaçamento
          ],
        ),
      ),
    );
  }
}

choiceToImage(String choice, bool other) {
  if (!other) {
    if (choice == "pedra") {
      return Image.asset(
        "imagens/user_rock.gif",
        height: 205.5,
        width: 205.5,
      );
    } else if (choice == "papel") {
      return Image.asset("imagens/user_paper.gif", height: 205.5, width: 205.5);
    } else {
      return Image.asset("imagens/user_scissors.gif",
          height: 205.5, width: 205.5);
    }
  } else {
    if (choice == "pedra") {
      return Image.asset(
        "imagens/grey_rock.gif",
        height: 205.5,
        width: 205.5,
      );
    } else if (choice == "papel") {
      return Image.asset("imagens/grey_paper.gif", height: 205.5, width: 205.5);
    } else {
      return Image.asset("imagens/grey_scissors.gif",
          height: 205.5, width: 205.5);
    }
  }
}

randomChoice() {
  var random = Random();
  var choice = random.nextInt(3);
  if (choice == 0) {
    return "pedra";
  } else if (choice == 1) {
    return "papel";
  } else {
    return "tesoura";
  }
}

class whoWon extends StatelessWidget {
  late String p1;
  late String p2;
  whoWon(p1, p2, {Key? key}) : super(key: key) {
    this.p1 = p1;
    this.p2 = p2;
  }

  @override
  Widget build(BuildContext context) {
    var ganhou = jogar(p1, p2);
    return Text(
      ganhou + " ganhou",
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(243, 170, 187, 1),
      ),
    );
  }
}
