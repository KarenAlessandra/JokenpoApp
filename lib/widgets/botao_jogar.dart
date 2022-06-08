import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotaoJogar extends StatelessWidget {
  final String title;
  final Function action;

  const BotaoJogar({
    Key? key,
    required this.title,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(244, 123, 143, 1));
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
    );
    return Padding(
      padding: const EdgeInsets.only(right: 55, left: 55, top: 10),
      child: OutlinedButton(
        style: TextButton.styleFrom(
          side: const BorderSide(
              width: 4, color: Color.fromRGBO(161, 220, 216, 1)),
          shape: forma,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          backgroundColor: const Color.fromRGBO(161, 220, 216, 1),
        ),
        onPressed: () {
          action();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: GoogleFonts.bebasNeue(fontSize: 32, textStyle: style))
          ],
        ),
      ),
    );
  }
}
