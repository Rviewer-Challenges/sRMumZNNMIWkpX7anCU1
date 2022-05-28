import 'package:injectable/injectable.dart';

import '../../utils/router.dart';
import '../../common/manager/view_manager.dart';

@injectable
class HomeManager extends ViewManager {
  // navigation
  void navigateToDifficultyMode() =>
      navigationService.pushNamed(AppRouter.difficultyModeRoute);

  void navigateToRanking() =>
      navigationService.pushNamed(AppRouter.rankingRoute);

  void navigateToSettings() =>
      navigationService.pushNamed(AppRouter.settingsRoute);
}
