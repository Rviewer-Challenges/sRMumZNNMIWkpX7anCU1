import '../../../../domain/model/score_model.dart';
import '../../../../objectbox.g.dart';
import '../database/app_database.dart';
import '../entity/score.dart';

abstract class ScoreDao {
  static Future<bool> storeScore(ScoreModel scoreItem) async {
    final scoreBox = AppDatabase.appDatabase.store.box<Score>();
    final List<Score> scores = scoreBox
        .query(Score_.name
            .equals(scoreItem.name)
            .and(Score_.difficultyId.equals(scoreItem.difficultyId)))
        .build()
        .find();

    scores.isNotEmpty
        ? scoreBox.put(scores.first
          ..setScore(scoreItem.score)
          ..setTime(scoreItem.timeInSeconds))
        : scoreBox.put(
            Score(
              scoreItem.name,
              scoreItem.difficultyId,
              scoreItem.score,
              scoreItem.timeInSeconds,
            ),
          );

    return true;
  }

  static Future<List<Score>> getScores() async {
    final scoreBox = AppDatabase.appDatabase.store.box<Score>();
    final QueryBuilder<Score> scoresQuery = scoreBox.query()
      ..order(
        Score_.score,
        flags: Order.descending,
      );

    final List<Score> scores = scoresQuery.build().find();
    return scores.isNotEmpty ? scores : [];
  }
}
