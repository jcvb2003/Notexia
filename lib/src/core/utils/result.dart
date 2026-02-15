import 'package:notexia/src/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

typedef Result<T> = Future<Either<Failure, T>>;
