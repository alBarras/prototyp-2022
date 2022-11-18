import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:prototyp_flutter/File/Bloc/bloc_storage.dart';
import 'package:prototyp_flutter/CodeAssets/string_constants.dart';
import 'package:prototyp_flutter/widgets/custom_dialog.dart';

Future<String> pickAndUploadFile(StorageBloc storageBloc, String fileName, context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ALLOWED_FILE_EXTENSIONS,
  );

  String extension = "";
  if (result != null) {
    File file = File(result.files.single.path!);
    extension = result.files.single.extension!;
    await storageBloc.uploadFile(file, fileName, extension, context).then((uploadedFile) {
      if (uploadedFile == null) {
        fileUploadedBadMsg(context);
      } else {
        fileUploadedOkMsg(context);
      }
    });
  } else {
    noFileSelectedMsg(context);
  }
  return extension;
}

void fileUploadedOkMsg(context) {
  List<VoidCallback?> buttonActions = [null];
  List<String> buttonTexts = [GENERAL_OK];
  showDialog(
    context: context,
    builder: (_) => CustomDialog(title: "File Correctly Uploaded", buttonActions: buttonActions, buttonTexts: buttonTexts),
    barrierDismissible: true,
  );
}

void fileUploadedBadMsg(context) {
  List<VoidCallback?> buttonActions = [null];
  List<String> buttonTexts = [GENERAL_OK];
  showDialog(
    context: context,
    builder: (_) => CustomDialog(title: "File Could Not Uploaded", buttonActions: buttonActions, buttonTexts: buttonTexts),
    barrierDismissible: true,
  );
}

void noFileSelectedMsg(context) {
  List<VoidCallback?> buttonActions = [null];
  List<String> buttonTexts = [GENERAL_OK];
  showDialog(
    context: context,
    builder: (_) => CustomDialog(title: "No File Selected", buttonActions: buttonActions, buttonTexts: buttonTexts),
    barrierDismissible: true,
  );
}
