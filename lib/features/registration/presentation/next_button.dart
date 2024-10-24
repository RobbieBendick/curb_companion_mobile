import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NextButton extends ConsumerStatefulWidget {
  final Function? onTap;
  final Function goNext;
  final Function validate;
  const NextButton(
      {super.key, required this.goNext, required this.validate, this.onTap});

  @override
  NextButtonState createState() => NextButtonState();
}

class NextButtonState extends ConsumerState<NextButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width * .8,
      child: ElevatedButton(
          onPressed: () {
            if (widget.onTap != null) widget.onTap!();
            if (widget.validate()) widget.goNext();
          },
          child: const Text("Next")),
    );
  }
}
