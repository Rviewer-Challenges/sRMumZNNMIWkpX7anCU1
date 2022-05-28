import 'package:flutter/material.dart';

import '../../../core/common/palette.dart';

abstract class CardStyles {
  static const Gradient easyBackDesign = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [.4, .4, .6, .6],
    colors: [
      Palette.red,
      Palette.black,
      Palette.black,
      Palette.white,
    ],
  );

  static const Gradient mediumBackDesign = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [.4, .4, .5, .5, .6, .6],
    colors: [
      Palette.blue,
      Palette.red,
      Palette.red,
      Palette.black,
      Palette.black,
      Palette.white,
    ],
  );

  static const Gradient hardBackDesign = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [.4, .4, .5, .5, .6, .6],
    colors: [
      Palette.black,
      Palette.yellow,
      Palette.yellow,
      Palette.black,
      Palette.black,
      Palette.white,
    ],
  );

  static const Gradient customBackDesign = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [.4, .4, .5, .5, .6, .6],
    colors: [
      Palette.purple,
      Palette.red,
      Palette.red,
      Palette.purple,
      Palette.purple,
      Palette.white,
    ],
  );
}
