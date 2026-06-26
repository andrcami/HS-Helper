# HS-Helper

Hearthstone advisor overlay. Reads live game state → recommends cards to play with % confidence. Built in Flutter for **Windows** and **Android**.

## Modes

- **Constructed** (Wild + Standard) — hand/board eval, effect + context-aware card-play scoring, mulligan advisor, HSReplay free-tier winrates.
- **Battlegrounds** — action-typed shop engine (buy/sell/roll/upgrade/freeze), tavern tier logic, Firestone tier data.

## How It Works

| Platform | Game state source |
|----------|-------------------|
| Windows  | Tails `Power.log` directly (`%LOCALAPPDATA%\Blizzard\Hearthstone\Logs\Power.log`) |
| Android  | MediaProjection screen capture → OCR/CV → same game state model |

Shared across both: recommendation engine, SQLite (drift) game history + data cache, overlay UI.

## Combat Simulator

Keyword-driven combat sim:
- Attack legality (exhausted / frozen / summoning-sick / rush / charge / stealth)
- Multi-attack planner — finds best full-turn attack sequence

## Scoring

```
score = (1 - personal_weight) * hsreplay_winrate + personal_weight * personal_winrate
personal_weight grows 0 → 0.3 as game count rises (min ~200 games)
```

## Data Sources

- **HSReplay** free tier — card winrates by class (aggregate)
- **Firestone** OSS — BGS tier lists JSON
- **Power.log** — real-time game events (free, local)
- **Local SQLite** — personal game history for personalized scoring

Refresh: manual UI button, or auto if cache > 7 days old. Re-pull after new set releases.

## Tech Stack

- Flutter (Dart) — unified Windows + Android
- `flutter_overlay_window`, `drift` (SQLite), `dio`, `riverpod`, `freezed`, `win32`

## Project Structure

```
lib/
  core/            # game state models, recommendation engine
  platform/
    windows/       # Power.log watcher
    android/       # MediaProjection bridge
  data/            # HSReplay + Firestone clients, cache manager
  overlay/         # overlay window + recommendation UI
  modes/
    constructed/   # hand/board scoring
    battlegrounds/ # shop phase + tavern tier logic
```

## Build

Requires Flutter (Windows desktop + Android toolchains).

```
flutter pub get
flutter run -d windows
```
