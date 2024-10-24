import 'package:curb_companion/features/registration/presentation/back_button.dart';
import 'package:curb_companion/features/registration/presentation/next_button.dart';
import 'package:flutter/material.dart';

class ImagePage extends StatefulWidget {
  final Function goNext;
  final Function goBack;
  const ImagePage({super.key, required this.goNext, required this.goBack});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CCBackButton(goBack: widget.goBack),
        NextButton(goNext: widget.goNext, validate: () => true),
      ],
    );
  }
}
