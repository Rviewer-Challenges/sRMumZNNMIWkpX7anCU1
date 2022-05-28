import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/common/custom_notifiers.dart';
import '../../../di/locator.dart';
import '../../../domain/model/score_model.dart';
import '../../../domain/use_case/score_use_case.dart';
import '../../common/manager/view_manager.dart';

@injectable
class RankingManager extends ViewManager {
  final GetScoresUseCase _getScoresUseCase = locator<GetScoresUseCase>();

  final CustomValueNotifier<List<ScoreModel>> _ranking =
      CustomValueNotifier<List<ScoreModel>>([]);
  CustomValueNotifier<List<ScoreModel>> get ranking => _ranking;

  // actions
  void getRanking() async {
    loading();

    final result = await runRequest<List<ScoreModel>>(
      functionRequest: () => _getScoresUseCase.getScores(),
      onSuccess: (result) => _ranking.value = result,
      onError: (errorType, message) {
        if (kDebugMode) {
          print('Error: $message');
        }
      },
    );

    loaded(result.isSuccessful);
  }

  @override
  void dispose() {
    _ranking.dispose();

    super.dispose();
  }
}
