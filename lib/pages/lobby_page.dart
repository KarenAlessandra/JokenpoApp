import 'package:flutter/material.dart';

class LobbyPage extends StatelessWidget {
  const LobbyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lobby'),
        backgroundColor: const Color.fromRGBO(161, 220, 216, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[
                SizedBox(
                  height: 200,
                  child: Text(
                    'Você é a NUMERO pessoa na fila',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(161, 220, 216, 1),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
