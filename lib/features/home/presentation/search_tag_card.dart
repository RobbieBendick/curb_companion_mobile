import 'package:curb_companion/features/theme/app/theme_service.dart';
import 'package:flutter/material.dart';

class SearchTagCard extends StatefulWidget {
  final String tag;
  final String? image;
  final Function? onTap;
  const SearchTagCard({
    Key? key,
    required this.tag,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  State<SearchTagCard> createState() => _SearchTagCardState();
}

class _SearchTagCardState extends State<SearchTagCard> {
  ThemeService themeService = ThemeService();
  double cardWidth = 182;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Expanded(
              child: widget.image != null
                  ? Ink.image(
                      fit: BoxFit.cover,
                      width: cardWidth,
                      image: NetworkImage(widget.image!),
                      child: InkWell(
                        onTap: () {
                          // put the tag's title in the search bar.
                          if (widget.onTap != null) {
                            widget.onTap!(widget.tag);
                          }
                        },
                      ),
                    )
                  : Ink.image(
                      fit: BoxFit.cover,
                      width: cardWidth,
                      image: const AssetImage(
                          'assets/images/default_menu_item.png'),
                      child: InkWell(
                        onTap: () {
                          // put the tag's title in the search bar.
                          if (widget.onTap != null) {
                            widget.onTap!(widget.tag);
                          }
                        },
                      ),
                    )),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
              color: Theme.of(context).iconTheme.color!.withOpacity(.7),
            ),
            width: cardWidth,
            height: 30,
            child: Center(
              child: Text(
                widget.tag,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
