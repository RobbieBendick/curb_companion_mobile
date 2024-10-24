import 'package:flutter/material.dart';

class HomeError extends StatelessWidget {
  final dynamic errorMessage;
  const HomeError({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        Center(
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    ));
  }
}
