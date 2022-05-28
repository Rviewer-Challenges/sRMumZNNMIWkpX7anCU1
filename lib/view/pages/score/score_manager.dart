import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../di/locator.dart';
import '../../../domain/model/score_model.dart';
import '../../../domain/use_case/score_use_case.dart';
import '../../utils/router.dart';
import '../../common/manager/view_manager.dart';

@injectable
class ScoreManager extends ViewManager {
  final SaveScoreUseCase _saveScoreUseCase = locator<SaveScoreUseCase>();

  // actions
  void saveScore(
      String name, int difficultyId, int score, int timeInSeconds) async {
    loading();

    final result = await runRequest(
      functionRequest: () => _saveScoreUseCase.saveScore(
        ScoreModel(
          name.trim(),
          difficultyId,
          score,
          timeInSeconds,
        ),
      ),
      onSuccess: (_) => navigateToRanking(),
      onError: (errorType, message) {
        if (kDebugMode) {
          print('Error: $message');
        }
      },
    );

    loaded(result.isSuccessful);
  }

  // navigation
  void navigateToRanking() =>
      navigationService.pushNamed(AppRouter.rankingRoute);
}
