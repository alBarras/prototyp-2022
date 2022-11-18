import 'dart:io';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:prototyp_flutter/CodeAssets/string_constants.dart';
import 'package:prototyp_flutter/widgets/custom_dialog.dart';
import 'package:path_provider/path_provider.dart';

class StorageBloc implements Bloc {
  Future<File?> uploadFile(File file, String name, String extension, context) async {
    //extension: xml, pdf, jpeg
    if (extension != "xml" && extension != "pdf" && extension != "jpeg") {
      incorrectFormatMsg(context);
      return null;
    }
    final storageRef = FirebaseStorage.instance.ref();
    try {
      await storageRef.child("prototyp/$name.$extension").putFile(file);
      return file;
    } catch (e) {
      errorUploadingMsg(context);
      return null;
    }
  }

  Future<bool> deleteFile(String name, String extension) async {
    final storageRef = FirebaseStorage.instance.ref();
    final desertRef = storageRef.child("prototyp/$name.$extension");
    await desertRef.delete();
    return true;
  }

  Future<File?> getFile(String name, String extension) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/$name.$extension');
    String fileToDownload = 'prototyp/$name.$extension';
    try {
      await FirebaseStorage.instance.ref(fileToDownload).writeToFile(downloadToFile);
    } catch (e) {
      print('Download error: $e');
    }
    return downloadToFile;
  }

  void incorrectFormatMsg(context) {
    List<VoidCallback?> buttonActions = [null];
    List<String> buttonTexts = [GENERAL_OK];
    showDialog(
      context: context,
      builder: (_) => CustomDialog(title: "Unallowed Extension", msg: "The only allowed file extensions are xml, pdf and jpeg.", buttonActions: buttonActions, buttonTexts: buttonTexts),
      barrierDismissible: true,
    );
  }

  void errorUploadingMsg(context) {
    List<VoidCallback?> buttonActions = [null];
    List<String> buttonTexts = [GENERAL_OK];
    showDialog(
      context: context,
      builder: (_) => CustomDialog(title: "Error Uploading File", msg: "Check your internet connection.", buttonActions: buttonActions, buttonTexts: buttonTexts),
      barrierDismissible: true,
    );
  }

  @override
  void dispose() {}
}
