import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
/// Failures are used in the Domain layer to represent errors in a way that
/// doesn't depend on specific platform or implementation details.
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'Failure: [$code] $message';
}

/// Failure representing a server error.
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server failure', super.code});
}

/// Failure representing a cache or local database error.
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache failure', super.code});
}

/// Failure representing a file system error.
class FileSystemFailure extends Failure {
  const FileSystemFailure({super.message = 'File system failure', super.code});
}

/// Failure representing a validation error.
class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation failure', super.code});
}

/// Failure representing an unauthorized access error.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized failure',
    super.code,
  });
}

/// Failure representing an unexpected error.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred',
    super.code,
  });
}
