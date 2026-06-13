# Hearthstone Power.log Skill

## Log Location
`%LOCALAPPDATA%\Blizzard\Hearthstone\Logs\Power.log`
Windows path: `C:\Users\<user>\AppData\Local\Blizzard\Hearthstone\Logs\Power.log`

## Key Log Patterns

### Game start
```
GameState.DebugPrintPower() - CREATE_GAME
```

### Card drawn
```
GameState.DebugPrintPower() - FULL_ENTITY - Updating Entity=[name=... id=... zone=HAND
```

### Card played
```
GameState.DebugPrintPower() - TAG_CHANGE Entity=... tag=ZONE value=PLAY
```

### Turn change
```
GameState.DebugPrintPower() - TAG_CHANGE Entity=GameEntity tag=TURN value=3
```

### Mana crystal
```
GameState.DebugPrintPower() - TAG_CHANGE Entity=... tag=RESOURCES value=7
```

### Game mode detection
```
GameState.DebugPrintPower() - TAG_CHANGE Entity=GameEntity tag=GAME_TYPE value=GT_RANKED
```
- `GT_RANKED` / `GT_CASUAL` = Constructed
- `GT_BATTLEGROUNDS` = Battlegrounds

### BGS shop phase
```
GameState.DebugPrintPower() - TAG_CHANGE Entity=... tag=STEP value=MAIN_ACTION
```

## Parser Strategy
1. Tail file with `win32` ReadFile + SetFilePointer (Windows) or inotify (Android)
2. Regex match lines → emit typed events
3. Accumulate events → rebuild GameState

## Existing Libraries
- `hearthstone_log_parser` (pub.dev) — covers basic events, may need extension for BGS
- Roll custom if BGS phase detection needed

## Entity ID Mapping
Cards identified by `id` integer in log. Map to card name via HearthstoneJSON:
`https://api.hearthstonejson.com/v1/latest/enUS/cards.collectible.json`
Cache locally. Key: `dbfId` → card name/cost/type.
