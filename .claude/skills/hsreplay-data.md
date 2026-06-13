# HSReplay + Data Sources Skill

## HSReplay Free Tier
Base URL: `https://hsreplay.net/api/v1/`

### Available free endpoints
- `GET /cards/` — card metadata
- `GET /decks/` — public deck lists
- Stats CSV downloads (no auth): aggregate winrates by class

### Free CSV stats
`https://hsreplay.net/analytics/query/card_played_popularity_report/?GameType=RANKED_STANDARD&RankRange=ALL&TimeRange=LAST_7_DAYS`

Returns: card played counts + winrates (aggregate, not deck-specific)

### Headers
```dart
dio.options.headers = {
  'X-CSRFToken': '', // not needed for public endpoints
  'User-Agent': 'HS-Helper/1.0',
};
```

## Firestone BGS Data
GitHub raw JSON:
`https://raw.githubusercontent.com/Zero-to-Heroes/firestone/main/libs/shared/common/src/lib/assets/data/battlegrounds-meta.json`

Or use their CDN: `https://static.zerotoheroes.com/hearthstone/data/`

## HearthstoneJSON (card definitions)
`https://api.hearthstonejson.com/v1/latest/enUS/cards.collectible.json`
Cache after first fetch. Refresh only on new set release (manual trigger).

## Cache Strategy (SQLite via drift)
```
card_stats table:
  card_id TEXT PK
  winrate REAL
  play_rate REAL
  fetched_at INTEGER (unix timestamp)
  source TEXT ('hsreplay' | 'personal')

bgs_tier_list table:
  minion_id TEXT PK
  tier INTEGER
  avg_placement REAL
  fetched_at INTEGER

data_manifest table:
  key TEXT PK  ('hsreplay_standard', 'firestone_bgs', 'card_definitions')
  fetched_at INTEGER
  version TEXT
```

## Refresh Logic
```dart
bool needsRefresh(String key) {
  final age = now() - manifest[key].fetchedAt;
  return age > Duration(days: 7);
}
// Manual override: RefreshButton calls forceRefresh()
```

## Rate Limiting
HSReplay free: ~100 req/day safe. Cache aggressively.
HearthstoneJSON: static files, no limit.
Firestone: GitHub raw, ~60 req/hour unauthenticated.
