import 'package:flutter/material.dart';
import 'package:prototyp_flutter/CodeAssets/size_constants.dart';

import '../CodeAssets/color_constants.dart';

// //EXAMPLE:
// List<VoidCallback?> buttonActions = [function,null];
// List<String> buttonTexts = ["Sí","No"];
// showDialog(
//   context: context,
//   builder: (_) => CustomDialog(title: "Vols pagar?", msg: "Segur?", buttonActions: buttonActions, buttonTexts: buttonTexts),
//   barrierDismissible: true,
// );

late AlertDialog _customAlertDialog;

Color defaultBgColor = DIALOG_BG;
Color defaultBorderColor = DIALOG_BORDER_COLOR;
double defaultBorderStroke = DIALOG_BORDER_STROKE;
Color defaultButtonTextColors = DIALOG_OK_BUTTON;
Color defaultQuitDialogButtonColor = DIALOG_CANCEL_BUTTON;
Color defaultTextColor = DIALOG_TEXT;

class CustomDialog extends StatefulWidget {
  // ..
  String? title, msg;

  List<VoidCallback?>? buttonActions;
  List<String>? buttonTexts;
  List<Color>? buttonTextColors;
  List<bool>? quitsDialog;
  String? quitDialogButtonText;
  Color? quitDialogButtonColor;
  Color? bgColor, borderColor;
  double? borderStroke;

  CustomDialog({this.title, this.bgColor, this.borderColor, this.borderStroke, this.msg, this.buttonActions, this.buttonTexts, this.quitsDialog, this.quitDialogButtonText, this.quitDialogButtonColor, this.buttonTextColors});

  @override
  State<StatefulWidget> createState() {
    return _CustomDialog();
  }
}

class _CustomDialog extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    //default quitsDialog
    if ((widget.quitsDialog == null || widget.quitsDialog == List.empty()) && widget.buttonTexts != null) {
      widget.quitsDialog = [];
      for (int i = 0; i < widget.buttonTexts!.length; i++) {
        widget.quitsDialog!.add(true);
      }
    }
    //default buttonTextColors
    if (widget.buttonTexts != null) {
      widget.buttonTextColors = [];
      for (int i = 0; i < widget.buttonTexts!.length; i++) {
        widget.buttonTextColors!.add(defaultButtonTextColors);
      }
    }
    //default quit button color
    widget.quitDialogButtonColor = defaultQuitDialogButtonColor;
    //defaul bgColor
    widget.bgColor ??= defaultBgColor;
    //defaul borderColor
    widget.borderColor ??= defaultBorderColor;
    //defaul borderStroke
    widget.borderStroke ??= defaultBorderStroke;

    Text? _title, _msg;
    if (widget.title == null || widget.title!.isEmpty) {
      _title = null;
    } else {
      _title = Text(
        widget.title!,
        style: TextStyle(color: defaultTextColor),
      );
    }
    if (widget.msg == null || widget.msg!.isEmpty) {
      _msg = null;
    } else {
      _msg = Text(widget.msg!, style: TextStyle(color: defaultTextColor));
    }

    //Buttons
    List<Widget> buttons = [];
    if (widget.buttonTexts != null && widget.buttonTexts!.length != 0) {
      for (int i = 0; i < widget.buttonTexts!.length; i++) {
        buttons.add(InkWell(
          child: Container(
            margin: const EdgeInsets.all(CUSTOM_DIALOG_TEXT_SPACE),
            child: Text(widget.buttonTexts![i], style: TextStyle(color: widget.buttonTextColors![i], fontFamily: "Lato", fontWeight: FontWeight.bold)),
          ),
          onTap: () {
            if (widget.quitsDialog![i]) {
              Navigator.pop(context);
            }
            if (widget.buttonActions![i] != null) {
              widget.buttonActions![i]!();
            }
          },
        ));
      }
    }
    if (widget.quitDialogButtonText != null && widget.quitDialogButtonText!.isNotEmpty) {
      buttons.add(InkWell(
        child: Container(
          margin: const EdgeInsets.all(CUSTOM_DIALOG_TEXT_SPACE),
          child: Text(widget.quitDialogButtonText!, style: TextStyle(color: widget.quitDialogButtonColor!, fontFamily: "Lato", fontWeight: FontWeight.bold)),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ));
    }

    _customAlertDialog = AlertDialog(
      //title & text
      title: _title,
      content: _msg,
      actions: buttons,
      elevation: 100.0,
      backgroundColor: widget.bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        side: BorderSide(
          color: widget.borderColor!,
          width: widget.borderStroke!,
        ),
      ),
      scrollable: true,
    );

    return _customAlertDialog;
  }
}
