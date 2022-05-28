import 'package:flutter/widgets.dart';

import '../../../core/common/palette.dart';
import '../../common/style/pictures.dart';
import 'game_configuration.dart';

enum DifficultyModeType {
  easy(
    0,
    lightColor: Palette.red,
    'Easy Mode',
    Pictures.easyIcon,
    'Difficulty for beginners:\n\n- Pokemon to catch: 6\n- Seconds to catch them all: 60',
    gameConfiguration: DefaultGameConfiguration.easy,
  ),
  medium(
    1,
    lightColor: Palette.blue,
    'Medium Mode',
    Pictures.mediumIcon,
    'Difficulty for a balanced game:\n\n- Pokemon to catch: 8\n- Seconds to catch them all: 50',
    gameConfiguration: DefaultGameConfiguration.medium,
  ),
  hard(
    2,
    lightColor: Palette.black,
    darkColor: Palette.yellow,
    'Hard Mode',
    Pictures.hardIcon,
    'Difficult for those looking for a challenge:\n\n- Pokemon to catch: 12\n- Seconds to catch them all: 40',
    gameConfiguration: DefaultGameConfiguration.hard,
  ),
  custom(
    3,
    lightColor: Palette.purple,
    'Custom Mode',
    Pictures.customIcon,
    'Customize the time and the number of Pokemon to catch.',
  );

  final int id;
  final Color lightColor;
  final Color? darkColor;
  final String text;
  final String difficultyIcon;
  final String description;
  final GameConfiguration? gameConfiguration;

  const DifficultyModeType(
    this.id,
    this.text,
    this.difficultyIcon,
    this.description, {
    this.gameConfiguration,
    required this.lightColor,
    this.darkColor,
  });
}
