import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldNonBorder extends StatefulWidget {
  final String? title;
  final String? hintText;
  final TextEditingController? controller;
  final VoidCallback? onPressedIcon;
  final VoidCallback? onTapTextField;
  final Function(String)? onTapGoButton;

  final bool? isPassword;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Color? colorBorder;
  final Color? colorTitle;
  final String? iconSuffix;
  final String? iconPrefix;
  final Color? colorHintText;
  final String? error;
  final Color? colorIcon;
  final Color? fillColor;
  final bool? obligatory;
  final bool? readOnly;
  final int? maxLength;
  final int? maxLine;
  final Key? keyText;
  final FocusNode? focus;
  final List<TextInputFormatter>? inputFormatter;

  const CustomTextFieldNonBorder({
    super.key,
    this.title,
    this.isPassword = false,
    this.keyboardType = TextInputType.multiline,
    this.colorBorder,
    this.iconSuffix,
    this.onChanged,
    this.iconPrefix,
    this.controller,
    this.hintText,
    this.onPressedIcon,
    this.colorIcon = Colors.black87,
    this.error,
    this.colorHintText = Colors.blueGrey,
    this.focus,
    this.fillColor = Colors.white,
    this.readOnly = false,
    this.onTapTextField,
    this.maxLength,
    this.maxLine = 1,
    this.inputFormatter,
    this.validator,
    this.keyText,
    this.onTapGoButton,
    this.colorTitle,
    this.obligatory,
  });

  @override
  _CustomTextFieldNonBorderState createState() =>
      _CustomTextFieldNonBorderState();
}

class _CustomTextFieldNonBorderState extends State<CustomTextFieldNonBorder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.keyText,
      child: TextField(
        autocorrect: false,
        textInputAction: TextInputAction.go,
        onSubmitted: (value) {
          widget.onTapGoButton!(value);
        },
        inputFormatters: widget.inputFormatter,
        maxLength: widget.maxLength,
        onTap: widget.onTapTextField,
        readOnly: widget.readOnly!,
        focusNode: widget.focus,
        maxLines: widget.maxLine,
        minLines: 1,
        cursorHeight: 22,
        obscureText: widget.isPassword!,
        onChanged: (value) {
          widget.onChanged!(value);
        },
        scrollPadding: const EdgeInsets.all(5),
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 17,
            color: widget.colorTitle),
        decoration: InputDecoration(
          errorText: widget.error,
          hintText: widget.hintText,
          labelStyle: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 18),
          hintStyle: const TextStyle(
              color: Colors.white60, fontWeight: FontWeight.w400, fontSize: 18),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}
