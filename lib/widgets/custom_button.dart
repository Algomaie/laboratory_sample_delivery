import 'package:alpha/utiles/styles.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final BorderSide? border;
  final double? height;
  final double? width;
  final double? fontSize;
  final double radius;
  final IconData? icon;
  final Color? color;
  CustomButton(
      {this.onPressed,
      this.border,
      required this.buttonText,
      this.transparent = false,
      this.margin,
      this.width,
      this.height,
      this.fontSize,
      this.radius = 5,
      this.icon,
      this.color});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null
          ? Theme.of(context).disabledColor
          : transparent
              ? Colors.transparent
              : color ?? Theme.of(context).primaryColor,
      minimumSize: Size(width ?? 1170, height ?? 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: border ?? BorderSide.none,
        borderRadius: BorderRadius.circular(radius),
      ),
    );

    return Center(
        child: SizedBox(
            width: width != null ? width : 1170,
            child: Padding(
              padding: margin ?? EdgeInsets.all(0),
              child: TextButton(
                onPressed: onPressed,
                style: _flatButtonStyle,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  icon != null
                      ? Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(icon,
                              color: transparent
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).cardColor),
                        )
                      : SizedBox(),
                  Text(buttonText ?? '',
                      textAlign: TextAlign.center,
                      style: robotoBold.copyWith(
                        // color: HexColor('#FFA921'),
                        color: transparent
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor,
                        fontSize: fontSize != null ? fontSize : 20,
                      )),
                ]),
              ),
            )));
  }
}
