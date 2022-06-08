import 'package:flutter/material.dart';
import 'package:projeto/widgets/leaderboard.dart';

class Online extends StatelessWidget {
  const Online({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(237, 237, 237, 1),
        appBar: AppBar(
          // title: const Text('Leaderboard'),
          backgroundColor: const Color.fromRGBO(161, 220, 216, 1),
          actions: [
            IconButton(
                icon: const Icon(Icons.workspace_premium_rounded,
                    color: Color.fromRGBO(81, 174, 174, 1)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Leaderboard()),
                  );
                })
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
        ));
  }
}
