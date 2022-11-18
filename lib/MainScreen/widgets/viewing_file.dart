import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prototyp_flutter/CodeAssets/color_constants.dart';
import 'package:prototyp_flutter/CodeAssets/string_constants.dart';
import 'package:prototyp_flutter/File/Model/model_file.dart';
import 'package:prototyp_flutter/widgets/button.dart';
import 'package:prototyp_flutter/widgets/custom_dialog.dart';
import 'package:prototyp_flutter/widgets/text_input.dart';
import 'package:prototyp_flutter/main.dart';

class ViewingFile extends StatelessWidget {
  VoidCallback onCancel, onOpen, onDelete;
  ModelFile? file;
  double? width, height;
  ViewingFile({Key? key, required this.file, required this.onCancel, required this.onOpen, required this.onDelete, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    width ??= safeAreaScreenWidth;
    height ??= safeAreaScreenHeight;

    return Stack(
      children: [
        InkWell(
          child: Container(),
          onTap: () {
            // onCancel();
          },
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(left: 50, right: 50),
            decoration: BoxDecoration(color: DIALOG_BG, borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      child: Icon(Icons.cancel_rounded),
                      onTap: () {
                        onCancel();
                      },
                    ),
                    const SizedBox(width: 15)
                  ],
                ),
                const SizedBox(height: 15),
                const Text("Name of the File", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 15),
                Text(file == null ? "" : (file!.name + "." + file!.extension), style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15)),
                const SizedBox(height: 30),
                const Text("Actions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Spacer(),
                    Button(
                      text: "Delete",
                      onTap: () {
                        askOnDelete(context);
                      },
                    ),
                    const SizedBox(width: 30),
                    Button(
                      text: "Open",
                      onTap: () {
                        onOpen();
                      },
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ],
    );
  }

  askOnDelete(context) {
    List<VoidCallback?> buttonActions = [actuallyDeleteFile, null];
    List<String> buttonTexts = [GENERAL_YES, GENERAL_NO];
    showDialog(
      context: context,
      builder: (_) => CustomDialog(title: "Are you Sure?", msg: "Do you really want to delete the file ${file == null ? "" : "${file!.name}.${file!.extension}"}?", buttonActions: buttonActions, buttonTexts: buttonTexts),
      barrierDismissible: true,
    );
  }

  actuallyDeleteFile() {
    onDelete();
  }
}
