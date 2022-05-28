import 'error_type.dart';

class Result<T> with SealedResult<T> {
  bool get isSuccessful => this is Success<T>;
}

class Success<T> extends Result<T> {
  T data;

  Success(this.data);
}

class Error<T> extends Result<T> {
  ErrorType type;
  String error;

  Error(this.type, this.error);
}

abstract class SealedResult<T> {
  R? when<R>({
    R Function(T)? success,
    R Function(ErrorType, String)? error,
  }) {
    if (this is Success<T>) {
      return success?.call((this as Success<T>).data);
    } else {
      // this is Error<T>
      return error?.call((this as Error<T>).type, (this as Error<T>).error);
    }
  }
}
