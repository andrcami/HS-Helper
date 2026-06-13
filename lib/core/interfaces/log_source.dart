abstract class LogSource {
  Stream<String> get lines;
  void dispose();
}
