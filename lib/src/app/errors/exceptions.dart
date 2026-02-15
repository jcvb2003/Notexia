/// Base class for all exceptions in the application.
abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException({required this.message, this.code});

  @override
  String toString() => 'AppException: [$code] $message';
}

/// Exception thrown when a server-side error occurs.
class ServerException extends AppException {
  ServerException({super.message = 'A server error occurred', super.code});
}

/// Exception thrown when a local database or cache error occurs.
class CacheException extends AppException {
  CacheException({super.message = 'A cache error occurred', super.code});
}

/// Exception thrown when a file system error occurs.
class FileSystemException extends AppException {
  FileSystemException({
    super.message = 'A file system error occurred',
    super.code,
  });
}

/// Exception thrown when validation fails.
class ValidationException extends AppException {
  ValidationException({super.message = 'Validation failed', super.code});
}

/// Exception thrown when the user is not authorized to perform an action.
class UnauthorizedException extends AppException {
  UnauthorizedException({super.message = 'Unauthorized access', super.code});
}
