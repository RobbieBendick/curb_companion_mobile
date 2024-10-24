import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool secureText;
  final Function? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool req;

  const CustomTextField(
      {Key? key,
      this.req = false,
      this.hintText,
      this.controller,
      this.validator,
      this.onChanged,
      this.keyboardType = TextInputType.text,
      this.inputFormatters = const [],
      this.secureText = false,
      this.maxLines})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
  }

  bool _showText = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        cursorColor: Colors.grey,
        maxLines: widget.maxLines ?? 1,
        validator: widget.validator,
        controller: widget.controller,
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged as void Function(String)?,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: widget.secureText
            ? InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      color:
                          Theme.of(context).iconTheme.color!.withOpacity(0.5),
                      width: 2.5), // Change the border color to green
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: widget.hintText,
                suffixIcon: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(right: 7.0),
                    child: IconButton(
                      onPressed: () => {
                        setState(() {
                          _showText = !_showText;
                        })
                      },
                      icon: _showText
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .color!
                          .withOpacity(.8),
                    ),
                  ),
                ),
              )
            : InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      color:
                          Theme.of(context).iconTheme.color!.withOpacity(0.5),
                      width: 2.5), // Change the border color to green
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                hintText: widget.hintText,
              ),
        obscureText: widget.secureText && !_showText,
      ),
    );
  }
}
