import 'package:alpha/utiles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final IconButton? suffixIcon;
  final bool isPassword;
  final Color? textColor;

  final OutlineInputBorder? border;
  final OutlineInputBorder? activeBorder;
  final OutlineInputBorder? enabledBorder;
  final Function(String)? onChanged;
  final Function? onSubmit;
  final bool isEnabled;
  final int maxLines;
  final TextCapitalization capitalization;
  final IconData? prefixIcon;
  final double prefixSize;
  final bool divider;
  final int? length;
  final TextAlign textAlign;
  final bool isAmount;
  final bool isNumber;
  final bool obscureText;
  final bool showTitle;
  final Color? fillColor;

  CustomTextField({
    this.hintText = 'اكتب من فضلك...',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSubmit,
    this.border,
    this.activeBorder,
    this.enabledBorder,
    this.onChanged,
    this.length,
    this.prefixIcon,
    this.suffixIcon,
    this.capitalization = TextCapitalization.none,
    this.isPassword = false,
    this.textColor,
    this.prefixSize = 10.0,
    this.divider = false,
    this.textAlign = TextAlign.start,
    this.isAmount = false,
    this.isNumber = false,
    this.obscureText = false,
    this.showTitle = false,
    this.fillColor,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.showTitle
            ? Text(widget.hintText, style: robotoRegular.copyWith(fontSize: 16))
            : SizedBox(),
        SizedBox(height: widget.showTitle ? 5 : 0),
        TextField(
          maxLines: widget.maxLines,
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: widget.textAlign,
          style: robotoRegular.copyWith(
              fontSize: 20, color: widget.textColor ?? Colors.black),
          textInputAction: widget.nextFocus == null
              ? TextInputAction.done
              : widget.inputAction,
          keyboardType:
              widget.isAmount ? TextInputType.number : widget.inputType,
          cursorColor: Theme.of(context).primaryColor,
          textCapitalization: widget.capitalization,
          enabled: widget.isEnabled,
          autofocus: false,
          obscureText: widget.obscureText,
          inputFormatters: widget.inputType == TextInputType.phone
              ? <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(9),
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ]
              : widget.isAmount
                  ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
                  : widget.isNumber
                      ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))]
                      : null,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8),

            border: widget.border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(style: BorderStyle.none, width: 0),
                ),
            focusedBorder: widget.activeBorder,
            enabledBorder: widget.enabledBorder,
            isDense: true,
            hintText: widget.hintText,
            fillColor: Colors.transparent,
            // fillColor: widget.fillColor ?? Theme.of(context).cardColor,
            hintStyle: robotoRegular.copyWith(
                fontSize: 16, color: widget.textColor ?? Colors.black),
            filled: true,
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: widget.prefixSize),
                    child: Icon(widget.prefixIcon,
                        size: 22,
                        color: widget.border != null
                            ? Colors.black
                            : Theme.of(context).hintColor),
                  )
                : null,
            suffixIcon: widget.isPassword ? widget.suffixIcon : null,
          ),
          onSubmitted: (text) => widget.nextFocus != null
              ? FocusScope.of(context).requestFocus(widget.nextFocus)
              : widget.onSubmit != null
                  ? widget.onSubmit!(text)
                  : null,
          onChanged: widget.onChanged,
        ),
        widget.divider
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider())
            : SizedBox(),
      ],
    );
  }
}
