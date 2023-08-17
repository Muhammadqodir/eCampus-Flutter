import 'package:ecampus_ncfu/inc/custom_checkbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReviewTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final Color baseColor;
  final Color errorColor;
  final TextInputType inputType;
  final TextAlign textAlign;
  final bool obscureText;
  final BorderRadius borderRadius;
  final List<TextInputFormatter> inputFormatter;
  final Function(String) onChanged;
  final Function(bool) onModeChanged;

  const ReviewTextField({
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
    required this.onModeChanged,
  });

  _ReviewTextFieldState createState() => _ReviewTextFieldState();
}

class _ReviewTextFieldState extends State<ReviewTextField> {
  Color currentColor = Colors.black12;

  @override
  void initState() {
    super.initState();
    currentColor = widget.baseColor;
  }

  bool isAnonymus = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.baseColor,
        borderRadius: widget.borderRadius,
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
          child: Row(
            children: [
              const SizedBox(width: 8,),
              CustomCheckBox(
                value: isAnonymus,
                size: 26,
                radius: 9,
                checkedIcon: CupertinoIcons.question,
                unCheckedIcon: CupertinoIcons.person,
                onChanged: (v){
                  widget.onModeChanged(v);
                  setState(() {
                    isAnonymus = v;
                  });
                },
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
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
                    // isDense: true,
                    border: InputBorder.none,
                    hintText: widget.hint + (isAnonymus ? " (Анонимно)":""),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
