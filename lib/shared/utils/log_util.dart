import 'dart:developer' as developer;

class LogUtil {
  /// General logging using dart:developer log to prevent string truncation
  static void log(
    String message, {
    String name = 'APP',
    Object? error,
    StackTrace? stackTrace,
    int level = 0,
  }) {
    developer.log(
      message,
      name: name,
      error: error,
      stackTrace: stackTrace,
      level: level,
    );
  }

  /// Info log
  static void info(String message, {String name = 'INFO'}) {
    developer.log(message, name: name);
  }

  /// Debug log
  static void debug(String message, {String name = 'DEBUG'}) {
    developer.log(message, name: name);
  }

  /// Warning log
  static void warning(String message, {String name = 'WARNING'}) {
    developer.log(message, name: name, level: 900);
  }

  /// Error log with optional error object & stack trace
  static void error(
    String message, {
    String name = 'ERROR',
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name,
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  /// Specialized helper for full API request/response logging
  static void api({
    required String endpoint,
    required String method,
    int? statusCode,
    dynamic requestBody,
    dynamic responseBody,
    String? tag,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('[$method] $endpoint');
    if (statusCode != null) {
      buffer.writeln('STATUS: $statusCode');
    }
    if (requestBody != null) {
      buffer.writeln('REQUEST: $requestBody');
    }
    if (responseBody != null) {
      buffer.writeln('RESPONSE: $responseBody');
    }
    developer.log(buffer.toString(), name: tag ?? 'API');
  }
}
