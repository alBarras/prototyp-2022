import 'package:flutter/material.dart';
import 'package:prototyp_flutter/CodeAssets/color_constants.dart';
import 'package:prototyp_flutter/main.dart';

class UploadingFile extends StatelessWidget {
  double? width, height;
  int mode; //1=uploading, -1:deleting
  UploadingFile({Key? key, required this.mode, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    width ??= safeAreaScreenWidth;
    height ??= safeAreaScreenHeight;

    return Container(
      width: width,
      height: height,
      color: TRANSP_BG,
      child: Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: CIRCULAR_WAITING,
              ),
              const SizedBox(height: 20),
              Text(
                mode == 1 ? "Uploading File" : "Deleting File",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
