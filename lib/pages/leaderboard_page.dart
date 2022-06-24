import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard'),
          backgroundColor: const Color.fromRGBO(161, 220, 216, 1),
        ),
        body: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 15)),
            // const Text(
            //   'Leaderboard',
            //   textAlign: TextAlign.start,
            //   style: TextStyle(
            //     fontSize: 30,
            //     fontWeight: FontWeight.bold,
            //     color: Color.fromRGBO(161, 220, 216, 1),
            //   ),
            // ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const <Widget>[
                  Image(
                    image: AssetImage('imagens/cat_king.gif'),
                    width: 200,
                  ),
                ]),
            ListBody(
              children: const <Widget>[
                ListTile(
                  textColor: Color.fromRGBO(81, 174, 174, 1),
                  leading: Icon(Icons.person,
                      color: Color.fromRGBO(81, 174, 174, 1)),
                  title: Text('Nome'),
                  subtitle: Text('Vitórias: ' +
                      '0' +
                      '\n' +
                      'Derrotas: ' +
                      '0' +
                      '\n' +
                      'Empates: ' +
                      '0'),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.emoji_events_rounded,
                      color: Color.fromRGBO(81, 174, 174, 1)),
                  title: Text('Nome'),
                  subtitle: Text('Vitórias: ' +
                      '0' +
                      '\n' +
                      'Derrotas: ' +
                      '0' +
                      '\n' +
                      'Empates: ' +
                      '0'),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading:
                      Icon(Icons.emoji_events_rounded, color: Colors.white),
                  title: Text('Nome'),
                  subtitle: Text('Vitórias: ' +
                      '0' +
                      '\n' +
                      'Derrotas: ' +
                      '0' +
                      '\n' +
                      'Empates: ' +
                      '0'),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading:
                      Icon(Icons.emoji_events_rounded, color: Colors.white),
                  title: Text('Nome'),
                  subtitle: Text('Vitórias: ' +
                      '0' +
                      '\n' +
                      'Derrotas: ' +
                      '0' +
                      '\n' +
                      'Empates: ' +
                      '0'),
                ),
              ],
            )
            //
          ],
        ));
  }
}
