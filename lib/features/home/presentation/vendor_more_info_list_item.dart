import 'package:flutter/material.dart';

class VendorMoreInfoListItem extends StatefulWidget {
  final Icon leadingIcon;
  final Icon? trailingIcon;
  final Icon? trailingIconClose;
  final String title;
  final bool? last;
  final Function? onTap;
  final Widget? expandedContent;

  const VendorMoreInfoListItem(
      {super.key,
      required this.title,
      required this.leadingIcon,
      this.trailingIcon,
      this.trailingIconClose,
      this.last,
      this.onTap,
      this.expandedContent});

  @override
  State<VendorMoreInfoListItem> createState() => _VendorMoreInfoListItemState();
}

class _VendorMoreInfoListItemState extends State<VendorMoreInfoListItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
            height: 0,
            color: Theme.of(context)
                .textTheme
                .bodyMedium!
                .color!
                .withOpacity(0.1)),
        InkWell(
          onTap: () {
            if (widget.expandedContent != null) {
              setState(() {
                expanded = !expanded;
              });
            }
            if (widget.onTap != null) widget.onTap!();
          },
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.leadingIcon,
                SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      if (widget.trailingIcon != null)
                        widget.expandedContent != null &&
                                expanded &&
                                widget.trailingIconClose != null
                            ? widget.trailingIconClose!
                            : widget.trailingIcon!,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        expanded && widget.expandedContent != null
            ? Column(
                children: [
                  Divider(
                      height: 0,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .color!
                          .withOpacity(0.1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 8.0),
                    child: widget.expandedContent!,
                  ),
                ],
              )
            : Container(),
        widget.last != true
            ? Divider(
                height: 1,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .color!
                    .withOpacity(0.1))
            : Divider(
                height: 0,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .color!
                    .withOpacity(0.1)),
      ],
    );
  }
}
