import '../common/result.dart';
import '../model/score_model.dart';

abstract class GetScoresUseCase {
  Future<Result<List<ScoreModel>>> getScores();
}

abstract class SaveScoreUseCase {
  Future<Result<void>> saveScore(ScoreModel scoreItem);
}
