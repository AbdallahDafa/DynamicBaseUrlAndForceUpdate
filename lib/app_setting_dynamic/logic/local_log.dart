import 'package:flutter/foundation.dart';

/// Simple console log with the time of the log.
class LocalLog {
  /// print key and message
  static void k(String tag, String msg) {
    i('$tag : $msg');
  }

  /// print message
  static void i(String msg) {
    String msgFinal = 'abdo : ${_getTimeOfLog()} : $msg';
    _printSpecial(msgFinal);
  }

  /// print object
  static void object(Object object) {
    String msg = 'abdo : ${_getTimeOfLog()} : $object';
    _printSpecial(msg);
  }

  /// print error
  ///
  /// working for error, example inside "try/catch" error
  static void e(String msg) {
    String msgFinal = 'abdo: error : ${_getTimeOfLog()} : $msg';
    _printSpecial(msgFinal);
  }

  //------------------------------------------------------------------- tools

  static void _printSpecial(String msg) {
    debugPrint(msg);
  }

  /// return format: hh:mm:ss:iii
  /// example:  03:09:06:009
  static String _getTimeOfLog() {
    DateTime now = DateTime.now();
    String h = now.hour.toString().padLeft(2, '0');
    String m = now.minute.toString().padLeft(2, '0');
    String s = now.second.toString().padLeft(2, '0');
    String i = now.millisecond.toString().padLeft(3, '0');
    return '$h:$m:$s:$i';
  }

  /// print big data in chunks of 800 characters,
  /// so the console doesn't cut it.
  static void logBidData(dynamic dataBig) {
    String data = '$dataBig';
    const int chunkSize = 800; // Adjust based on your console limits
    for (int i = 0; i < data.length; i += chunkSize) {
      final chunk = data.substring(
          i, i + chunkSize > data.length ? data.length : i + chunkSize);

      if (i == 0) _printSpecial('abdo : ${_getTimeOfLog()} : BIG DATA:');
      _printSpecial(chunk);
    }
  }
}
