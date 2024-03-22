class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message (${code ?? "no-code"})';
}

class ValidationException extends AppException {
  ValidationException(String message, {String? code}) : super(message, code: code ?? 'VALIDATION_ERROR');
}

class StorageException extends AppException {
  StorageException(String message, {dynamic details}) : super(message, code: 'STORAGE_ERROR', details: details);
}

class NotFoundException extends AppException {
  NotFoundException(String message) : super(message, code: 'NOT_FOUND');
}
