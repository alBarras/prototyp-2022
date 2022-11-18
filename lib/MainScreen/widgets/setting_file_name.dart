import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prototyp_flutter/CodeAssets/color_constants.dart';
import 'package:prototyp_flutter/CodeAssets/string_constants.dart';
import 'package:prototyp_flutter/widgets/button.dart';
import 'package:prototyp_flutter/widgets/custom_dialog.dart';
import 'package:prototyp_flutter/widgets/text_input.dart';
import 'package:prototyp_flutter/main.dart';

class SettingFileNames extends StatelessWidget {
  final Function(String) onNameTextChanged, onUserTextChanged, onDescriptionTextChanged;
  VoidCallback onEnd, onCancel;
  double? width, height;
  SettingFileNames({Key? key, required this.onCancel, required this.onEnd, required this.onNameTextChanged, required this.onUserTextChanged, required this.onDescriptionTextChanged, this.width, this.height}) : super(key: key);

  String fileName = "", userName = "", description = "";

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
                CustomTextInput(
                  controller: TextEditingController(),
                  initialText: "",
                  hasNext: false,
                  hintText: "File Name",
                  textInputType: TextInputType.text,
                  onChanged: (text) {
                    fileName = text;
                    onNameTextChanged(text);
                  },
                ),
                const SizedBox(height: 25),
                const Text("Name of the User", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 15),
                CustomTextInput(
                  controller: TextEditingController(),
                  initialText: "",
                  hasNext: false,
                  hintText: "File Name",
                  textInputType: TextInputType.text,
                  onChanged: (text) {
                    userName = text;
                    onUserTextChanged(text);
                  },
                ),
                const SizedBox(height: 25),
                const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 15),
                CustomTextInput(
                  controller: TextEditingController(),
                  initialText: "",
                  hasNext: false,
                  hintText: "File Name",
                  textInputType: TextInputType.text,
                  onChanged: (text) {
                    description = text;
                    onDescriptionTextChanged(text);
                  },
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    const Spacer(),
                    Button(
                      text: "Upload",
                      onTap: () {
                        if (fileName.isEmpty) {
                          List<VoidCallback?> buttonActions = [null];
                          List<String> buttonTexts = [GENERAL_OK];
                          showDialog(
                            context: context,
                            builder: (_) => CustomDialog(title: "The name of the file can not be empty", buttonActions: buttonActions, buttonTexts: buttonTexts),
                            barrierDismissible: true,
                          );
                        } else if (userName.isEmpty) {
                          List<VoidCallback?> buttonActions = [null];
                          List<String> buttonTexts = [GENERAL_OK];
                          showDialog(
                            context: context,
                            builder: (_) => CustomDialog(title: "The name of the user can not be empty", buttonActions: buttonActions, buttonTexts: buttonTexts),
                            barrierDismissible: true,
                          );
                        } else if (description.isEmpty) {
                          List<VoidCallback?> buttonActions = [null];
                          List<String> buttonTexts = [GENERAL_OK];
                          showDialog(
                            context: context,
                            builder: (_) => CustomDialog(title: "The description can not be empty", buttonActions: buttonActions, buttonTexts: buttonTexts),
                            barrierDismissible: true,
                          );
                        } else {
                          onEnd();
                        }
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
}
