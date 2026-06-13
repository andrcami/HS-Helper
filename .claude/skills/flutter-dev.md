# Flutter Dev Skill

## Trigger
When writing Flutter/Dart code for HS-Helper.

## Rules
- Always use `freezed` for data models — never mutable classes
- State via `riverpod` providers — no `setState` except in leaf widgets
- Platform code behind abstract interfaces: `core/` defines interface, `platform/windows/` and `platform/android/` implement
- Use `drift` for all SQLite — no raw SQL strings
- Overlay windows: always `flutter_overlay_window`, never raw platform channels for this

## Patterns

### Provider pattern
```dart
@riverpod
Stream<GameState> gameState(GameStateRef ref) {
  return ref.watch(logWatcherProvider).gameStateStream;
}
```

### Freezed model
```dart
@freezed
class GameState with _$GameState {
  const factory GameState({
    required List<CardInHand> hand,
    required Board board,
    required int mana,
    required GameMode mode,
  }) = _GameState;
}
```

### Platform interface
```dart
// core/interfaces/log_source.dart
abstract class LogSource {
  Stream<String> get lines;
  void dispose();
}
```

## Package versions (pubspec.yaml)
- flutter_overlay_window: ^0.4.0
- drift: ^2.x
- riverpod: ^2.x / hooks_riverpod
- freezed: ^2.x
- dio: ^5.x
- win32: ^5.x
