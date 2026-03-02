/// Custom exception for API-related errors.
class ApiException implements Exception {
  /// Human-readable error message.
  final String message;

  /// HTTP status code returned by the server (if any).
  final int? statusCode;

  /// Creates an [ApiException] with a [message] and optional [statusCode].
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}