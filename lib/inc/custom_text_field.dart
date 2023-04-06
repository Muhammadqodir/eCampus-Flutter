import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final Color baseColor;
  final Color errorColor;
  final TextInputType inputType;
  final TextAlign textAlign;
  final bool obscureText;
  BorderRadius borderRadius;
  List<TextInputFormatter> inputFormatter;
  final Function(String) onChanged;

  CustomTextField({
    this.hint = "",
    required this.controller,
    required this.onChanged,
    this.baseColor = Colors.black12,
    this.errorColor = Colors.red,
    this.textAlign = TextAlign.start,
    this.inputFormatter = const [],
    this.inputType = TextInputType.text,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.obscureText = false,
  });

  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  Color currentColor = Colors.black12;

  @override
  void initState() {
    super.initState();
    currentColor = widget.baseColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.baseColor,
        borderRadius: widget.borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
        child: TextField(
          obscureText: widget.obscureText,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatter,
          textAlign: widget.textAlign,
          keyboardType: widget.inputType,
          enableSuggestions: !widget.obscureText,
          autocorrect: !widget.obscureText,
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            border: InputBorder.none,
            hintText: widget.hint,
          ),
        ),
      ),
    );
  }
}
