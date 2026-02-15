import 'package:notexia/src/core/errors/failure.dart';

abstract class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(Failure failure) = Error<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Error<T>;

  T? get data => this is Success<T> ? (this as Success<T>).value : null;
  Failure? get failure => this is Error<T> ? (this as Error<T>).error : null;
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Error<T> extends Result<T> {
  final Failure error;
  const Error(this.error);
}
