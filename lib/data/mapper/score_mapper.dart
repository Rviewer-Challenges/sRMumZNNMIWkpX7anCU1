import '../../domain/model/score_model.dart';
import '../datasource/local/entity/score.dart';

extension ScoreExtension on Score {
  ScoreModel toModel() => ScoreModel(
        name,
        difficultyId,
        score,
        timeInSeconds,
      );
}
