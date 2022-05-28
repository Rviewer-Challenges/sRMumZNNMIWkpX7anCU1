import 'package:found_pairs/view/utils/game_utils/difficulty_mode_type.dart';

class ScoreModel {
  final String name;
  final int difficultyId;
  final int score;
  final int timeInSeconds;

  ScoreModel(this.name, this.difficultyId, this.score, this.timeInSeconds);

  String get difficultyIcon => DifficultyModeType.values
      .singleWhere(
        (element) => element.id == difficultyId,
        orElse: () => DifficultyModeType.easy,
      )
      .difficultyIcon;
}
