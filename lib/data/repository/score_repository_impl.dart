import 'package:injectable/injectable.dart';

import '../../domain/common/result.dart';
import '../../domain/model/score_model.dart';
import '../../domain/repository/score_repository.dart';
import '../datasource/local/dao/score_dao.dart';
import '../datasource/local/entity/score.dart';
import '../mapper/score_mapper.dart';
import 'base/base_repository.dart';

@Injectable(as: ScoreRepository)
class ScoreRepositoryImpl extends BaseRepository implements ScoreRepository {
  @override
  Future<Result<List<ScoreModel>>> getScores() => safeDbCall(
        ScoreDao.getScores(),
        mapper: (List<Score> scores) => scores.map((e) => e.toModel()).toList(),
      );

  @override
  Future<Result<void>> saveScore(ScoreModel scoreItem) => safeDbCall(
        ScoreDao.storeScore(scoreItem),
        mapper: (_) {},
      );
}
