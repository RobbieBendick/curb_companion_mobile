import 'package:flutter/material.dart';

class DraggableRectangle extends StatelessWidget {
  const DraggableRectangle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.4,
      width: MediaQuery.of(context).size.width * 0.30,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
    );
  }
}
