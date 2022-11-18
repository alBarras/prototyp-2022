import 'package:flutter/material.dart';
import 'package:prototyp_flutter/CodeAssets/color_constants.dart';
import 'package:prototyp_flutter/main.dart';

class Background extends StatelessWidget {
  double? width, height;
  Background({Key? key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    width ??= safeAreaScreenWidth;
    height ??= safeAreaScreenHeight;

    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            BACKGROUND_A,
            BACKGROUND_B,
          ],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              BACKGROUND_TOP,
              BACKGROUND_BOT,
            ],
            begin: FractionalOffset(1.0, 0),
            end: FractionalOffset(1.0, 1.0),
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    );
  }
}
