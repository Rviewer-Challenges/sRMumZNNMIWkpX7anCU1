import 'dart:math';

import 'package:found_pairs/view/utils/game_utils/difficulty_mode_type.dart';
import 'package:found_pairs/view/utils/game_utils/game_configuration.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/custom_notifiers.dart';
import '../../../common/manager/view_manager.dart';
import '../../../common/style/audio.dart';
import '../../../common/style/card_styles.dart';
import '../../../utils/router.dart';
import '../../board/board_arguments.dart';

@injectable
class CustomModeManager extends ViewManager {
  final List<int> numberOfPairsList = [6, 8, 12];

  final CustomValueNotifier<int> _selectedNumberOfPairs =
      CustomValueNotifier(6);
  CustomValueNotifier<int> get selectedNumberOfPairs => _selectedNumberOfPairs;

  final CustomValueNotifier<int> _selectedMinutes = CustomValueNotifier(0);
  CustomValueNotifier<int> get selectedMinutes => _selectedMinutes;

  final CustomValueNotifier<int> _selectedSeconds = CustomValueNotifier(0);
  CustomValueNotifier<int> get selectedSeconds => _selectedSeconds;

  // setters
  void selectNumberOfPairs(int value) => _selectedNumberOfPairs.value = value;

  void selectMinutes(int value) => _selectedMinutes.value = value;

  void selectSeconds(int value) => _selectedSeconds.value = value;

  // navigation
  void navigateToBoard() => navigationService.pushNamedWithArguments(
        AppRouter.boardRoute,
        BoardArguments(
          DifficultyModeType.custom.id,
          _createGameConfiguration(),
        ),
      );

  GameConfiguration _createGameConfiguration() => GameConfiguration(
        _selectedNumberOfPairs.value,
        _selectedMinutes.value * 60 + _selectedSeconds.value,
        _setCardColumnsNumber(),
        CardStyles.customBackDesign,
        Audio.game[Random().nextInt(Audio.game.length)],
      );

  int _setCardColumnsNumber() => (_selectedNumberOfPairs.value <= 6) ? 3 : 4;

  @override
  void dispose() {
    _selectedNumberOfPairs.dispose();
    _selectedMinutes.dispose();
    _selectedSeconds.dispose();
  }
}
