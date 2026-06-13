import 'package:flutter/foundation.dart';

class LogBuffer extends ChangeNotifier {
  final List<String> _lines = [];
  List<String> get lines => List.unmodifiable(_lines);

  void add(String line) {
    _lines.add(line);
    if (_lines.length > 500) _lines.removeAt(0);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}
