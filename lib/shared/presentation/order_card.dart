import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({super.key});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.91,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Vendor Title",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_right,
                      size: 20,
                      color: Theme.of(context).textTheme.displaySmall!.color,
                      weight: 20,
                    ),
                  ],
                ),
                Divider(
                  thickness: 0.5,
                  color: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .color!
                      .withOpacity(0.65),
                )
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.91,
            child: const Row(
              children: [Text("Wednesday • Jan 26 • \$24.20 • 1 item")],
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.91,
            child: const Row(
              children: [
                Text(
                  "Western Bacon Burger",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.91,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Reorder",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "View Receipt",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Divider(
            thickness: 5,
            color:
                Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}
