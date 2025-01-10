import 'package:logger/logger.dart';

var logger = Logger();

class Loggy {
  static void debug(dynamic message) {
    logger.d(message);
  }

  static void info(dynamic message) {
    logger.i(message);
  }

  static void warn(dynamic message) {
    logger.w(message);
  }

  static void error(dynamic message) {
    logger.e(message);
  }

  static void fatal(dynamic message) {
    logger.f(message);
  }
}
