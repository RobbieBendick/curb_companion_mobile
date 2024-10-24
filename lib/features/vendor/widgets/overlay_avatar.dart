import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverlayAvatar extends ConsumerWidget {
  final String? vendorImage;
  const OverlayAvatar(this.vendorImage, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: 120,
      right: MediaQuery.of(context).size.width / 2 - 30, // middle of screen
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            vendorImage ?? 'https://source.unsplash.com/random/150x150',
          ),
        ),
      ),
    );
  }
}
