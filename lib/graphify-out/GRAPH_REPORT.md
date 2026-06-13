# Graph Report - C:\dev-Projects\HS-Helper\lib  (2026-06-13)

## Corpus Check
- 29 files · ~34,861 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 263 nodes · 293 edges · 18 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]

## God Nodes (most connected - your core abstractions)
1. `_` - 22 edges
2. `package:logger/logger.dart` - 10 edges
3. `../../data/cache_manager.dart` - 7 edges
4. `dart:io` - 6 edges
5. `../../core/game_state.dart` - 6 edges
6. `dart:convert` - 6 edges
7. `_` - 6 edges
8. `../core/recommendation.dart` - 5 edges
9. `package:flutter/foundation.dart` - 5 edges
10. `package:flutter/material.dart` - 4 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Communities

### Community 0 - "Community 0"
Cohesion: 0.06
Nodes (37): byte, Deckstring, DecodedDeck, varint, _VarReader, add, clear, LogBuffer (+29 more)

### Community 1 - "Community 1"
Cohesion: 0.07
Nodes (28): build, CacheStatusBar, Column, Container, dispose, Divider, _EmptyState, _EmptyStateState (+20 more)

### Community 2 - "Community 2"
Cohesion: 0.08
Nodes (24): build, _CardDbCard, _ClassWinRateCard, Column, Container, Dashboard, _DeckRow, _DeckShelfCard (+16 more)

### Community 3 - "Community 3"
Cohesion: 0.09
Nodes (22): build, _checkHs, dispose, HsHelperApp, initState, _isHearthstoneRunning, main, _MainOverlay (+14 more)

### Community 4 - "Community 4"
Cohesion: 0.1
Nodes (21): _, battlegrounds, BattlegroundsGameState, _BgsMinion, _BgsState, _Board, _CardInHand, CheckedFromJsonException (+13 more)

### Community 5 - "Community 5"
Cohesion: 0.12
Nodes (15): CardDbClient, CardMeta, _parseRarity, _parseType, BgsTierEntry, FirestoneClient, _parse, _tierFromPlacement (+7 more)

### Community 6 - "Community 6"
Cohesion: 0.12
Nodes (15): BoardEval, _keywordValue, minionValue, score, sideValue, swing, _applyHeroDamage, _cleanup (+7 more)

### Community 7 - "Community 7"
Cohesion: 0.12
Nodes (15): fromState, KeywordParser, SimBoard, SimMinion, _toSim, _buildState, CardInHand, _emitGameEnd (+7 more)

### Community 8 - "Community 8"
Cohesion: 0.15
Nodes (11): BgsMinion, BgsState, Board, CardInHand, ConstructedState, GameState, MinionOnBoard, BgsRecommendation (+3 more)

### Community 9 - "Community 9"
Cohesion: 0.15
Nodes (12): _beginTailing, _checkForNewerSession, _defaultLogPath, dispose, _openOrWait, _poll, _pollUntilExists, _reopen (+4 more)

### Community 10 - "Community 10"
Cohesion: 0.17
Nodes (11): _boardPressure, _cardReason, _cardScore, ConstructedEngine, _manaEfficiency, _swingToScore, _tradeReason, ../../core/sim/board_eval.dart (+3 more)

### Community 11 - "Community 11"
Cohesion: 0.17
Nodes (10): BgsEngine, _shouldFreeze, _shouldUpgradeTavern, build, Container, RecommendationCard, SizedBox, Text (+2 more)

### Community 12 - "Community 12"
Cohesion: 0.33
Nodes (5): clone, has, removeDead, SimBoard, SimMinion

### Community 13 - "Community 13"
Cohesion: 0.5
Nodes (5): _, _BgsRecommendation, identical, _then, toString

### Community 14 - "Community 14"
Cohesion: 0.67
Nodes (2): GameRecord, HistoryStats

### Community 15 - "Community 15"
Cohesion: 0.67
Nodes (2): dispose, LogSource

### Community 16 - "Community 16"
Cohesion: 1.0
Nodes (1): heroClassFromCardId

### Community 17 - "Community 17"
Cohesion: 1.0
Nodes (0): 

## Knowledge Gaps
- **215 isolated node(s):** `HsHelperApp`, `_MainOverlay`, `_MainOverlayState`, `main`, `build` (+210 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Community 16`** (2 nodes): `hero_class.dart`, `heroClassFromCardId`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 17`** (1 nodes): `game_state.g.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `../../data/cache_manager.dart` connect `Community 7` to `Community 1`, `Community 2`, `Community 3`, `Community 10`, `Community 11`?**
  _High betweenness centrality (0.286) - this node is a cross-community bridge._
- **Why does `package:logger/logger.dart` connect `Community 5` to `Community 0`, `Community 9`, `Community 3`, `Community 7`?**
  _High betweenness centrality (0.191) - this node is a cross-community bridge._
- **Why does `sim_models.dart` connect `Community 6` to `Community 7`?**
  _High betweenness centrality (0.098) - this node is a cross-community bridge._
- **What connects `HsHelperApp`, `_MainOverlay`, `_MainOverlayState` to the rest of the system?**
  _215 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.06 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.07 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._