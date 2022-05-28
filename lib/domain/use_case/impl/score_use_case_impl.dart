import 'package:injectable/injectable.dart';

import '../../common/result.dart';
import '../../model/score_model.dart';
import '../../repository/score_repository.dart';
import '../score_use_case.dart';

@Injectable(as: GetScoresUseCase)
class GetScoreUseCaseImpl extends GetScoresUseCase {
  final ScoreRepository _repository;

  GetScoreUseCaseImpl(this._repository);

  @override
  Future<Result<List<ScoreModel>>> getScores() => _repository.getScores();
}

@Injectable(as: SaveScoreUseCase)
class SaveScoreUseCaseImpl extends SaveScoreUseCase {
  final ScoreRepository _repository;

  SaveScoreUseCaseImpl(this._repository);

  @override
  Future<Result<void>> saveScore(ScoreModel scoreItem) =>
      _repository.saveScore(scoreItem);
}
