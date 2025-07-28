import 'dart:developer';

class Logger {
  // Logs an informational message.
  static void info(String message, {String tag = 'INFO'}) {
    log('[INFO] [$tag] $message');
  }

  // Logs a warning message.
  static void warning(String message, {String tag = 'WARNING'}) {
    log('[WARNING] [$tag] $message');
  }

  // Logs an error message.
  static void error(String message, {String tag = 'ERROR', dynamic error, StackTrace? stackTrace}) {
    log(
      '[ERROR] [$tag] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  // Logs a debug message.
  static void debug(String message, {String tag = 'DEBUG'}) {
    log('[DEBUG] [$tag] $message');
  }
}