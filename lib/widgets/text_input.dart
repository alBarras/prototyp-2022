import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final Function(String)? onChanged;

  String? initialText;
  bool? isPwd = false;
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController? controller;
  int? maxLines;
  final bool hasNext; //true = when pressing enter it will jump to the next input field,    false = do nothing
  bool? autofocus;
  FocusNode? focusNode;

  CustomTextInput({this.onChanged, this.initialText, this.isPwd, required this.hintText, required this.textInputType, this.controller, this.maxLines, required this.hasNext, this.autofocus, this.focusNode});

  @override
  _CustomTextInput createState() => _CustomTextInput();
}

class _CustomTextInput extends State<CustomTextInput> {
  @override
  Widget build(BuildContext context) {
    //Initial Text
    // TextInputAction textInputAction;
    // if (widget.hasNext) {
    //   textInputAction = TextInputAction.next;
    // } else {
    //   textInputAction = TextInputAction.none;
    // }
    if (widget.initialText == null || widget.initialText!.isEmpty) {
      widget.initialText = "";
    }

    widget.isPwd ??= false;

    if (widget.controller != null) {
      widget.controller!.text = widget.initialText!;
      widget.controller!.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller!.text.length));
    }

    return Container(
        padding: const EdgeInsets.only(right: 20.0, left: 20.0),
        child: TextField(
            focusNode: widget.focusNode != null ? widget.focusNode! : null,
            autofocus: widget.autofocus != null ? widget.autofocus! : false,
            onChanged: (text) {
              if (widget.onChanged != null) {
                widget.onChanged!(text);
              }
            },
            controller: (widget.controller != null)
                ? widget.controller
                // ..text = widget.initialText!
                // ..selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length))
                : null,
            //textInputAction: TextInputAction.next, //go-done=enter, next=next item, none=do nothing
            keyboardType: widget.textInputType,
            obscureText: widget.isPwd!,
            maxLines: widget.maxLines ??= 1,
            style: const TextStyle(fontSize: 15.0, fontFamily: "Lato", color: Colors.black, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              hintText: widget.hintText,
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(9.0))),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(9.0))),
            )));
  }
}
