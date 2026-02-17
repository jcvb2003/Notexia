import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'Failure: ${code != null ? '[$code] ' : ''}$message';
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.code});
}

class PersistenceFailure extends Failure {
  const PersistenceFailure(super.message, {super.code});
}

class FileSystemFailure extends Failure {
  const FileSystemFailure(super.message, {super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.code});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.code});
}
