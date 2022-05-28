import 'package:injectable/injectable.dart';

import '../../../core/common/custom_notifiers.dart';
import '../../utils/game_utils/difficulty_mode_type.dart';
import '../../utils/router.dart';
import '../../common/manager/view_manager.dart';
import '../board/board_arguments.dart';

@injectable
class DifficultyModeManager extends ViewManager {
  final CustomValueNotifier<DifficultyModeType> _difficultySelected =
      CustomValueNotifier(DifficultyModeType.easy);
  CustomValueNotifier<DifficultyModeType> get difficultySelected =>
      _difficultySelected;

  // setters
  void selectDifficulty(DifficultyModeType type) =>
      _difficultySelected.value = type;

  // navigation
  void exitFromPage() =>
      _difficultySelected.value.id == DifficultyModeType.custom.id
          ? _navigateToCustomMode()
          : _navigateToBoard();

  void _navigateToCustomMode() =>
      navigationService.pushNamed(AppRouter.customModeRoute);

  void _navigateToBoard() => navigationService.pushNamedWithArguments(
        AppRouter.boardRoute,
        BoardArguments(
          _difficultySelected.value.id,
          _difficultySelected.value.gameConfiguration!,
        ),
      );

  @override
  void dispose() {
    _difficultySelected.dispose();

    super.dispose();
  }
}
