import 'package:found_pairs/view/utils/game_utils/game_configuration.dart';

class BoardArguments {
  final int _difficultyId;
  final GameConfiguration _gameConfiguration;

  BoardArguments(this._difficultyId, this._gameConfiguration);

  int get difficultyId => _difficultyId;

  GameConfiguration get gameConfiguration => _gameConfiguration;
}
