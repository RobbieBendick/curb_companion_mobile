import 'package:flutter/material.dart';

class CustomRoundedChip extends StatelessWidget {
  final String label;
  final Widget? avatar;
  final Icon? icon;
  final VoidCallback? onPressed;

  const CustomRoundedChip({
    Key? key,
    required this.label,
    this.avatar,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: onPressed,
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .color!
                      .withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (avatar != null) ...[
                      avatar!,
                      const SizedBox(width: 5),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: 5),
                      icon!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
