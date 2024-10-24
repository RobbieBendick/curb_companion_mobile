import 'package:flutter/material.dart';

class CCBackButton extends StatelessWidget {
  final Function goBack;
  const CCBackButton({super.key, required this.goBack});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          goBack();
        },
        child: Text("Back",
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color)));
  }
}
