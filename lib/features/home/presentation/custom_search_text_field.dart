import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomSearchTextField extends ConsumerStatefulWidget {
  final Function()? onTap;
  final String? hintText;
  final Function? updatePageIndex;
  final Function(String)? onFieldSubmitted;
  final bool? autoFocus;
  final bool? backArrow;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final dynamic provider;
  const CustomSearchTextField({
    Key? key,
    this.onTap,
    this.hintText,
    this.updatePageIndex,
    this.autoFocus,
    this.backArrow,
    this.onFieldSubmitted,
    this.onChanged,
    this.controller,
    this.provider,
  }) : super(key: key);

  @override
  CustomSearchTextFieldState createState() => CustomSearchTextFieldState();
}

class CustomSearchTextFieldState extends ConsumerState<CustomSearchTextField> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 0.93 * MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .color!
                  .withOpacity(.5),
              spreadRadius: 1,
              blurRadius: 1,
            )
          ],
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: TextFormField(
          onFieldSubmitted: widget.onFieldSubmitted != null
              ? (value) {
                  widget.onFieldSubmitted!(value);
                }
              : null,
          controller: widget.controller ?? searchController,
          autofocus: widget.autoFocus ?? false,
          enabled: widget.onTap != null ? false : true,
          onChanged: (value) {
            EasyDebounce.debounce(
              'search',
              const Duration(milliseconds: 500),
              () {
                setState(() {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  } else {
                    searchController.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: value.length),
                      ),
                    );
                  }
                });
              },
            );
          },
          decoration: InputDecoration(
            suffixIcon: (widget.controller != null
                    ? widget.controller!.text.isNotEmpty
                    : searchController.text.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (widget.controller != null) {
                            widget.controller!.clear();
                            // close the keyboard
                          } else {
                            searchController.clear();
                          }
                          // refresh the page and state
                          if (mounted) {
                            ref.invalidate(widget.provider);
                            FocusScope.of(context).unfocus();
                          }
                        });
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  )
                : null,
            prefixIcon: widget.backArrow == true
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  )
                : const Icon(Icons.search),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.7),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: widget.hintText ?? 'Search for vendors & events',
          ),
        ),
      ),
    );
  }
}
