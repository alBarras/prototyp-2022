import 'package:flutter/material.dart';
import 'package:prototyp_flutter/CodeAssets/color_constants.dart';

class Button extends StatefulWidget {
  VoidCallback? onTap;

  String? text;
  Color? textColor;
  double? textSize;
  bool? textIsBold;

  IconData? iconData;
  Color? iconColor;
  double? iconSize;
  double? rotateIconDegrees;

  IconData? iconData2;
  Color? iconColor2;
  double? iconSize2;
  double? rotateIconDegrees2;

  Color? bgColor;
  double? borderRadius;
  EdgeInsets? padding, margin;

  Button({
    Key? key,
    this.onTap,
    this.text,
    this.textColor,
    this.textSize,
    this.textIsBold,
    this.iconData,
    this.iconColor,
    this.iconSize,
    this.rotateIconDegrees,
    this.iconData2,
    this.iconColor2,
    this.iconSize2,
    this.rotateIconDegrees2,
    this.bgColor,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  State<StatefulWidget> createState() {
    return ButtonState();
  }
}

class ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    widget.onTap ??= () {};
    widget.text ??= "";
    widget.textSize ??= 15;
    widget.textIsBold ??= false;
    widget.iconData ??= Icons.abc;
    widget.iconSize ??= 25;
    widget.rotateIconDegrees ??= 0;
    if (widget.textColor == null && widget.iconColor != null) widget.textColor = widget.iconColor;
    if (widget.iconColor == null && widget.textColor != null) widget.iconColor = widget.textColor;
    widget.textColor ??= Colors.black;
    widget.iconColor ??= Colors.black;
    widget.iconData2 ??= Icons.abc;
    widget.iconColor2 ??= widget.iconColor;
    widget.iconSize2 ??= widget.iconSize;
    widget.rotateIconDegrees2 ??= 0;
    widget.bgColor ??= GENERAL_BUTTON;
    widget.borderRadius ??= 10;
    widget.padding ??= const EdgeInsets.all(10);
    widget.margin ??= const EdgeInsets.all(0);

    return InkWell(
      onTap: widget.onTap!,
      child: Container(
        padding: widget.padding!,
        margin: widget.margin!,
        decoration: BoxDecoration(
          color: widget.bgColor!,
          borderRadius: BorderRadius.circular(widget.borderRadius!),
        ),
        child: Row(children: [
          Visibility(
            visible: widget.text != "",
            child: Text(
              widget.text!,
              style: TextStyle(
                color: widget.textColor!,
                fontSize: widget.textSize!,
                fontWeight: widget.textIsBold! ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Visibility(
            visible: widget.text != "" && widget.iconData != Icons.abc,
            child: const SizedBox(width: 5),
          ),
          Visibility(
            visible: widget.iconData != Icons.abc,
            child: RotationTransition(
                turns: AlwaysStoppedAnimation(widget.rotateIconDegrees! / 360),
                child: Icon(
                  widget.iconData!,
                  size: widget.iconSize!,
                  color: widget.iconColor!,
                )),
          ),
          Visibility(
            visible: widget.iconData2 != Icons.abc,
            child: const SizedBox(width: 5),
          ),
          Visibility(
            visible: widget.iconData2 != Icons.abc,
            child: RotationTransition(
                turns: AlwaysStoppedAnimation(widget.rotateIconDegrees2! / 360),
                child: Icon(
                  widget.iconData2!,
                  size: widget.iconSize2!,
                  color: widget.iconColor2!,
                )),
          ),
        ]),
      ),
    );
  }
}
