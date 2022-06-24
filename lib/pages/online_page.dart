import 'package:flutter/gestures.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 70,
                  width: 300,
                  child: ElevatedButton(
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
                    child: const Text('Entrar no lobby',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(244, 123, 143, 1),
                        )),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 70,
                  width: 300,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(161, 220, 216, 1),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Leaderboard()),
                      );
                    },
                    child: const Text('Leaderboard',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(244, 123, 143, 1))),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 70,
                  width: 300,
                  child: ElevatedButton(
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
                    child: const Text('Logoff',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(244, 123, 143, 1))),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
