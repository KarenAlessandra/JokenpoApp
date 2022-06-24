import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projeto/widgets/botao_jogar.dart';
import 'package:projeto/widgets/logica.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'home_page.dart';
import 'jokenpo_page.dart';

class JokenpoFightPage extends StatefulWidget {
  late String escolha;
  late String pc;
  late Image escolhaImage;
  late Image pcImage;
  // const JokenpoFightPage({Key? key, escolha = String}) : super(key: key);
  JokenpoFightPage(escolha, {Key? key}) {
    this.escolha = escolha;
    pc = randomChoice();
    escolhaImage = choiceToImage(escolha, false);
    pcImage = choiceToImage(pc, true);
  }

  @override
  State<JokenpoFightPage> createState() => _JokenpoFightPageState();
}

class _JokenpoFightPageState extends State<JokenpoFightPage> {
  late ScreenshotController screenshotController;

  void dispose() {
    widget.escolhaImage.image.evict();
    widget.pcImage.image.evict();
  }

  @override
  void initState() {
    super.initState();
    screenshotController = ScreenshotController();
  }

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(244, 123, 143, 1));
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Builder(builder: (context) {
        return Screenshot(
          controller: screenshotController,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(padding: EdgeInsets.all(65.0)), // espaçamento
                AnimatedTextKit(
                  repeatForever: false,
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    WavyAnimatedText('JO KEN PÔ!',
                        textStyle: style,
                        speed: const Duration(milliseconds: 220)),
                  ],
                ),
                //row aqui
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    widget.escolhaImage,
                    widget.pcImage,
                  ],
                ),
                whoWon(widget.escolha, widget.pc),

                BotaoJogar(
                    title: "Jogar novamente",
                    action: () {
                      dispose();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const JokenpoPage(),
                          // maintainState: false
                        ),
                      );
                    }),
                BotaoJogar(
                    title: "Voltar ao Menu",
                    action: () {
                      dispose();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }),
                BotaoJogar(
                    title: "Captura de tela",
                    action: () async {
                      dispose();
                      final image = await screenshotController.capture();
                      // Share.shareFiles([image]);
                    }),
                const Padding(padding: EdgeInsets.all(25.0)),
                // espaçamento
              ],
            ),
          ),
        );
      }),
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
      return Image.asset(
        "imagens/user_paper.gif",
        height: 205.5,
        width: 205.5,
      );
    } else {
      return Image.asset(
        "imagens/user_scissors.gif",
        height: 205.5,
        width: 205.5,
      );
    }
  } else {
    if (choice == "pedra") {
      return Image.asset(
        "imagens/grey_rock.gif",
        height: 205.5,
        width: 205.5,
      );
    } else if (choice == "papel") {
      return Image.asset(
        "imagens/grey_paper.gif",
        height: 205.5,
        width: 205.5,
      );
    } else {
      return Image.asset(
        "imagens/grey_scissors.gif",
        height: 205.5,
        width: 205.5,
      );
    }
  }
}

randomChoice() {
  var random = Random();
  var choice = random.nextInt(3);
  if (choice == 0) {
    return "Pedra";
  } else if (choice == 1) {
    return "Papel";
  } else {
    return "Tesoura";
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
      ganhou + " ganhou!",
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(243, 170, 187, 1),
      ),
    );
  }
}
