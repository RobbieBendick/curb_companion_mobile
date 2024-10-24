import 'package:flutter/material.dart';

class PoweredByGoogle extends StatelessWidget {
  const PoweredByGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: const TextSpan(
            text: "Powered by ",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            children: [
              TextSpan(
                text: "G",
                style: TextStyle(
                  color: Color(0xFF4285F4), // Google blue
                ),
              ),
              TextSpan(
                text: "o",
                style: TextStyle(
                  color: Color(0xFFEA4335), // Google red
                ),
              ),
              TextSpan(
                text: "o",
                style: TextStyle(
                  color: Color(0xFFFBBC05), // Google yellow
                ),
              ),
              TextSpan(
                text: "g",
                style: TextStyle(
                  color: Color(0xFF4285F4), // Google blue
                ),
              ),
              TextSpan(
                text: "l",
                style: TextStyle(
                  color: Color(0xFF34A853), // Google green
                ),
              ),
              TextSpan(
                text: "e",
                style: TextStyle(
                  color: Color(0xFFEA4335), // Google red
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
