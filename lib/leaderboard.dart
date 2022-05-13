import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(237, 237, 237, 1),
        appBar: AppBar(
          // title: const Text('Leaderboard'),
          backgroundColor: const Color.fromRGBO(161, 220, 216, 1),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Leaderboard',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(161, 220, 216, 1),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const <Widget>[
                  Image(
                    image: AssetImage('imagens/cat_king.gif'),
                    width: 200,
                  ),
                ]),
            const Text("teste"),
          ],
        ));
  }
}
