# HS-Helper — Claude Code Context

## Project
Hearthstone advisor overlay app. Flutter (Windows + Android).
Reads game state → recommends cards to play with % confidence.

## Modes
- **Constructed** (Wild + Standard): hand/board eval, HSReplay free-tier winrates
- **Battlegrounds**: shop phase econ, tavern tier logic, Firestone tier data

## Platform Strategy
- Windows: tail `Power.log` directly (`%LOCALAPPDATA%\Blizzard\Hearthstone\Logs\Power.log`)
- Android: MediaProjection screen capture → OCR/CV → same game state model
- Shared: recommendation engine, SQLite (drift), overlay UI

## Tech Stack
- Flutter (Dart) — unified Windows + Android
- `flutter_overlay_window` — overlay on both platforms
- `drift` — SQLite ORM for game history + data cache
- `dio` — HTTP client
- `riverpod` — state management
- `freezed` — immutable models
- `win32` — Windows log file watching

## Data Sources
- HSReplay free tier: card winrates by class (aggregate)
- Firestone OSS (GitHub): BGS tier lists JSON
- Power.log: real-time game events (free, local)
- Local SQLite: personal game history for personalized scoring

## Scoring Formula
```
score = (1 - personal_weight) * hsreplay_winrate + personal_weight * personal_winrate
personal_weight grows from 0 → 0.3 as game count increases (min ~200 games)
```

## Data Refresh
Manual trigger via UI button. Also auto-refreshes if cache > 7 days old.
Triggered after new set releases. Pulls HSReplay CSV + Firestone JSON.

## Project Structure
```
lib/
  core/           # game state models, recommendation engine
  platform/
    windows/      # Power.log watcher
    android/      # MediaProjection bridge
  data/           # HSReplay + Firestone clients, cache manager
  overlay/        # overlay window + recommendation UI widgets
  modes/
    constructed/  # hand/board scoring logic
    battlegrounds/ # shop phase + tavern tier logic
```

## Build Order (current phase: scaffolding)
1. Flutter project scaffold + pubspec.yaml
2. Game state models (constructed + BGS)
3. Windows Power.log watcher
4. Data layer (HSReplay fetch + SQLite cache)
5. Constructed recommendation engine
6. Overlay UI (Windows first)
7. BGS engine
8. Android MediaProjection bridge
9. Personal training loop

## Key Files
- `lib/core/game_state.dart` — shared game state models
- `lib/platform/windows/log_watcher.dart` — Power.log real-time tailer
- `lib/data/hsreplay_client.dart` — free tier API client
- `lib/data/cache_manager.dart` — refresh logic
- `lib/overlay/overlay_window.dart` — transparent topmost window

## Conventions
- Immutable models via `freezed`
- All async via `riverpod` providers
- No business logic in widgets
- Platform-specific code behind abstract interfaces in `core/`
