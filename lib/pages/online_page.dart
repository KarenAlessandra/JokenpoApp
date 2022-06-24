import 'package:flutter/material.dart';
import 'package:projeto/pages/lobby_page.dart';
import 'package:projeto/pages/login_page.dart';
import 'package:projeto/services/auth_service.dart';
import 'package:projeto/pages/leaderboard_page.dart';
import 'package:provider/provider.dart';

class Online extends StatelessWidget {
  const Online({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(237, 237, 237, 1),
        appBar: AppBar(
          // title: const Text('Leaderboard'),
          backgroundColor: const Color.fromRGBO(161, 220, 216, 1),
          // actions: [
          //   IconButton(
          //       icon: const Icon(Icons.workspace_premium_rounded,
          //           color: Color.fromRGBO(81, 174, 174, 1)),
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const Leaderboard()),
          //         );
          //       })
          // ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(161, 220, 216, 1),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LobbyPage()),
                      );
                    },
                    child: const Text('Entrar no lobby')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(161, 220, 216, 1)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Leaderboard()),
                    );
                  },
                  child: Text('Leaderboard'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(161, 220, 216, 1)),
                  onPressed: () {
                    context.read<AuthService>().logout();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: Text('Logoff'),
                ),
              ],
            )
          ],
        ));
  }
}
