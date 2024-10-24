import 'package:flutter/material.dart';
import 'package:curb_companion/features/theme/app/theme_service.dart';
import 'package:provider/provider.dart' as provider;

class NotificationCard extends StatelessWidget {
  final bool read;
  final String? imageUrl;
  final String description;
  final String timeAgo;
  final Function onTap;

  const NotificationCard({
    Key? key,
    required this.read,
    this.imageUrl,
    required this.description,
    required this.timeAgo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Stack(
        children: [
          !read
              ? Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightBlue),
                  ))
              : Container(),
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl!,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            provider.Provider.of<ThemeService>(context,
                                        listen: false)
                                    .isDarkMode()
                                ? 'assets/images/default_vendor_dark.png'
                                : 'assets/images/logo.svg',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeAgo,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).textTheme.displaySmall!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color
                    ?.withOpacity(0.455))
          ]),
        ],
      ),
    );
  }
}
