# Graph Report - C:\dev-Projects\HS-Helper\lib  (2026-06-13)

## Corpus Check
- 30 files · ~38,948 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 277 nodes · 305 edges · 19 communities detected
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
- [[_COMMUNITY_Community 18|Community 18]]

## God Nodes (most connected - your core abstractions)
1. `_` - 22 edges
2. `package:logger/logger.dart` - 10 edges
3. `../../data/cache_manager.dart` - 7 edges
4. `dart:io` - 6 edges
5. `../../core/game_state.dart` - 6 edges
6. `dart:convert` - 6 edges
7. `../core/recommendation.dart` - 5 edges
8. `package:flutter/foundation.dart` - 5 edges
9. `package:flutter/material.dart` - 4 edges
10. `sim_models.dart` - 4 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Communities

### Community 0 - "Community 0"
Cohesion: 0.06
Nodes (35): add, clear, LogBuffer, CacheManager, Duration, _loadCardDb, _persist, _persistCardDb (+27 more)

### Community 1 - "Community 1"
Cohesion: 0.07
Nodes (28): build, CacheStatusBar, Column, Container, dispose, Divider, _EmptyState, _EmptyStateState (+20 more)

### Community 2 - "Community 2"
Cohesion: 0.08
Nodes (22): board_eval.dart, AttackPlan, AttackPlanner, AttackStep, plan, search, BoardEval, _keywordValue (+14 more)

### Community 3 - "Community 3"
Cohesion: 0.08
Nodes (24): build, _CardDbCard, _ClassWinRateCard, Column, Container, Dashboard, _DeckRow, _DeckShelfCard (+16 more)

### Community 4 - "Community 4"
Cohesion: 0.08
Nodes (23): build, _checkHs, dispose, HsHelperApp, initState, _isHearthstoneRunning, main, _MainOverlay (+15 more)

### Community 5 - "Community 5"
Cohesion: 0.09
Nodes (20): CardDbClient, CardMeta, _parseRarity, _parseType, CardWinrate, HsReplayClient, _parseCsv, _buildState (+12 more)

### Community 6 - "Community 6"
Cohesion: 0.1
Nodes (21): _, battlegrounds, BattlegroundsGameState, _BgsMinion, _BgsState, _Board, _CardInHand, CheckedFromJsonException (+13 more)

### Community 7 - "Community 7"
Cohesion: 0.11
Nodes (16): BgsEngine, _buyReason, _buyScore, _rollReason, _rollScore, _shouldFreeze, _tribalMultiplier, _upgradeReason (+8 more)

### Community 8 - "Community 8"
Cohesion: 0.15
Nodes (12): _boardPressure, _cardReason, _cardScore, ConstructedEngine, _contextMultiplier, _hints, _manaEfficiency, _swingToScore (+4 more)

### Community 9 - "Community 9"
Cohesion: 0.15
Nodes (12): _beginTailing, _checkForNewerSession, _defaultLogPath, dispose, _openOrWait, _poll, _pollUntilExists, _reopen (+4 more)

### Community 10 - "Community 10"
Cohesion: 0.18
Nodes (9): BgsRecommendation, Recommendation, fromState, KeywordParser, SimBoard, SimMinion, _toSim, ../../data/cache_manager.dart (+1 more)

### Community 11 - "Community 11"
Cohesion: 0.22
Nodes (8): BgsMinion, BgsState, Board, CardInHand, ConstructedState, GameState, MinionOnBoard, package:freezed_annotation/freezed_annotation.dart

### Community 12 - "Community 12"
Cohesion: 0.29
Nodes (6): byte, Deckstring, DecodedDeck, varint, _VarReader, dart:typed_data

### Community 13 - "Community 13"
Cohesion: 0.33
Nodes (5): clone, has, removeDead, SimBoard, SimMinion

### Community 14 - "Community 14"
Cohesion: 0.67
Nodes (2): GameRecord, HistoryStats

### Community 15 - "Community 15"
Cohesion: 0.67
Nodes (2): dispose, LogSource

### Community 16 - "Community 16"
Cohesion: 0.67
Nodes (2): CardEffectHints, _word

### Community 17 - "Community 17"
Cohesion: 1.0
Nodes (1): heroClassFromCardId

### Community 18 - "Community 18"
Cohesion: 1.0
Nodes (0): 

## Knowledge Gaps
- **229 isolated node(s):** `HsHelperApp`, `_MainOverlay`, `_MainOverlayState`, `main`, `build` (+224 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Community 17`** (2 nodes): `hero_class.dart`, `heroClassFromCardId`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 18`** (1 nodes): `game_state.g.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `../../data/cache_manager.dart` connect `Community 10` to `Community 1`, `Community 3`, `Community 4`, `Community 5`, `Community 7`, `Community 8`?**
  _High betweenness centrality (0.273) - this node is a cross-community bridge._
- **Why does `package:logger/logger.dart` connect `Community 5` to `Community 0`, `Community 9`, `Community 4`?**
  _High betweenness centrality (0.177) - this node is a cross-community bridge._
- **Why does `sim_models.dart` connect `Community 2` to `Community 10`?**
  _High betweenness centrality (0.134) - this node is a cross-community bridge._
- **What connects `HsHelperApp`, `_MainOverlay`, `_MainOverlayState` to the rest of the system?**
  _229 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.06 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.07 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._