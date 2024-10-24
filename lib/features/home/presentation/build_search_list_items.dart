import 'package:curb_companion/routes/routes.dart';
import 'package:flutter/material.dart';

class BuildSearchListItems extends StatefulWidget {
  final String title;
  final List<dynamic> items;
  final Icon icon;
  final Function(String) onChanged;
  const BuildSearchListItems({
    super.key,
    required this.title,
    required this.items,
    required this.icon,
    required this.onChanged,
  });

  @override
  State<BuildSearchListItems> createState() => _BuildSearchListItemsState();
}

class _BuildSearchListItemsState extends State<BuildSearchListItems> {
  @override
  Widget build(BuildContext context) {
    bool isRecentSearchesRow = widget.title == "Recent Searches";

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 17.0),
          child: Row(
            mainAxisAlignment: isRecentSearchesRow
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isRecentSearchesRow)
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, Routes.seeMoreRecentSearchesScreen);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      "See More",
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        for (var item in widget.items)
          Column(
            children: [
              SizedBox(
                height: 45,
                child: InkWell(
                  onTap: () {
                    widget.onChanged(item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        widget.icon, // Search icon on the left
                        const SizedBox(
                          width: 15,
                        ), // Add some space between the icon and text
                        Text(
                          item,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 15),
      ],
    );
  }
}
