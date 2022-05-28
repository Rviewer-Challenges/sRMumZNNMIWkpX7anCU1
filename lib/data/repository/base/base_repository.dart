import 'package:flutter/foundation.dart';

import '../../../domain/common/error_type.dart';
import '../../../domain/common/result.dart';

typedef EntityToModelMapper<Entity, Model> = Model Function(Entity entity);
typedef ResponseToModelMapper<Response, Model> = Model Function(
    Response response);
typedef SaveResult<Response> = Future Function(Response response);

abstract class BaseRepository {
  Future<Result<Model>> safeDbCall<Entity, Model>(Future<Entity?> call,
      {required EntityToModelMapper<Entity, Model> mapper}) async {
    try {
      final response = await call;

      if (response != null) {
        if (kDebugMode) {
          print('DB success message -> $response');
        }
        return Success(mapper.call(response));
      } else {
        if (kDebugMode) {
          print('DB response is null');
        }
        return Error(ErrorType.generic, 'DB response is null');
      }
    } catch (e) {
      if (kDebugMode) {
        print('DB failure message -> $e');
      }
      return Error(ErrorType.generic, 'Unknow DB error');
    }
  }
}
