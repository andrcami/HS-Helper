import 'package:logger/logger.dart';
import '../../core/game_state.dart';
import '../../core/game_record.dart';
import '../../core/hero_class.dart';
import '../../data/cache_manager.dart';

final _log = Logger();

/// Tracked entity state, built from bracket fields + tag changes in the log.
class _Entity {
  _Entity(this.id);
  final int id;
  String? name;
  String? cardId;
  String zone = 'UNKNOWN';
  int? player;
  int zonePos = 0; // 0 = hero, >=1 = board minion slot
  int atk = 0;
  int health = 0;
  int damage = 0; // damage taken (effective health = health - damage)
  bool taunt = false;
  bool divineShield = false;
  bool windfury = false;
  bool exhausted = false; // summoning sickness / already attacked → can't attack
  bool frozen = false; // FROZEN → can't attack this turn
  bool stealth = false;
  bool rush = false;
  bool charge = false;
  bool justPlayed = false; // entered PLAY this turn (summoning sickness source)
  String cardType = ''; // MINION / WEAPON / HERO / HERO_POWER / SPELL

  int get effectiveHealth => health - damage;

  /// Can this minion attack ANY target right now?
  /// Sick (just played) blocks attack UNLESS charge (any) or rush (minions only).
  /// Exhausted (already attacked) and frozen always block.
  bool get canAttack {
    if (frozen) return false;
    if (exhausted) return false;
    if (justPlayed && !charge && !rush) return false;
    return true;
  }

  /// Can it attack the enemy HERO this turn? Rush played this turn can hit
  /// minions only, not face.
  bool get canAttackFace {
    if (!canAttack) return false;
    if (justPlayed && rush && !charge) return false;
    return true;
  }
}

class PowerLogParser {
  PowerLogParser({this.cache, this.onGameEnd, this.onCardSeen});
  final CacheManager? cache;

  /// Called once when a game completes, with the finished game's record.
  final void Function(GameRecord)? onGameEnd;

  /// Called for each local-player cardId observed (games, collection, decks).
  /// Builds the approximate collection over time.
  final void Function(String cardId)? onCardSeen;

  GameMode? _mode;
  int _mana = 0;
  int _maxMana = 0;
  int _turn = 0;
  bool _isPlayerTurn = false;
  // True once CURRENT_PLAYER mapped to a real PlayerID at least once. Until then
  // the mana-refresh fallback drives _isPlayerTurn (mid-session watcher start).
  bool _currentPlayerMapped = false;
  // Mulligan phase: game STEP=BEGIN_MULLIGAN → ends at first MAIN_* step.
  bool _isMulligan = false;
  bool _hasCoin = false; // local player is on the coin (going second)
  String _playerClass = 'UNKNOWN';

  // Local player's controller id. Discovered from cards revealed in hand.
  int? _localPlayerId;

  // Per-player hero class (player id → class name).
  final Map<int, String> _heroClass = {};
  bool _gameEnded = false;
  int? _format; // 1 = wild, 2 = standard (FormatType)
  int? _losingPlayer; // player id whose hero hit the graveyard

  // entity id → tracked entity
  final Map<int, _Entity> _entities = {};

  static final _gameType = RegExp(r'GameType=(GT_\w+)');
  static final _formatType = RegExp(r'FormatType=FT_(\w+)');
  // Hero entity bracket: cardId=HERO_xxx player=N — gives class per player.
  static final _heroEntity = RegExp(r'cardId=(HERO_\w+) player=(\d+)\]');
  // A hero entity moving to GRAVEYARD = that player lost.
  static final _heroDeath = RegExp(
      r'\[entityName=.*? cardId=(HERO_\w+) player=(\d+)\] tag=ZONE value=GRAVEYARD');
  // Game completion marker.
  static final _gameComplete =
      RegExp(r'Entity=GameEntity tag=STATE value=COMPLETE');
  // Game STEP changes — used to bound the mulligan phase.
  static final _gameStep =
      RegExp(r'Entity=GameEntity tag=(?:NEXT_)?STEP value=(\w+)');

  // Any bracketed entity: [entityName=NAME ... id=N ... zone=ZONE zonePos=P cardId=X player=P]
  // entityName may itself contain "[cardType=INVALID]" so name capture is greedy-lazy up to " id=".
  static final _bracket = RegExp(
      r'\[entityName=(.*?) (?:\[cardType=\w+\] )?id=(\d+) zone=(\w+) zonePos=(-?\d+) cardId=(\S*) player=(\d+)\]');

  // Hero power used count for the local player's hero (0 this turn = usable).
  int _heroPowerUsedThisGame = 0;
  int _lastHeroPowerUsed = 0; // snapshot at turn start to detect per-turn usage

  // TAG_CHANGE with bracketed entity → capture id, tag, value
  static final _tagBracket = RegExp(r'TAG_CHANGE Entity=\[.*? id=(\d+) .*?\] tag=(\w+) value=(\S+)');
  // TAG_CHANGE with plain numeric entity
  static final _tagPlain = RegExp(r'TAG_CHANGE Entity=(\d+) tag=(\w+) value=(\S+)');

  // Maps a player NAME to its PlayerID: "PlayerID=1, PlayerName=LuckyOwl#214329".
  static final _playerName = RegExp(r'PlayerID=(\d+), PlayerName=(.+?)\s*$');
  // Mana lives on the NAMED player entity, not a numeric/bracket id:
  // "TAG_CHANGE Entity=LuckyOwl#214329 tag=RESOURCES value=10".
  static final _namedResource =
      RegExp(r'TAG_CHANGE Entity=(\S+) tag=(RESOURCES|RESOURCES_USED) value=(\d+)');

  // player name → PlayerID (which equals the bracket player= / _localPlayerId).
  final Map<String, int> _nameToPlayer = {};

  // player-entity id (e.g. 2, 3) → PlayerID (1, 2). From "Player EntityID=N PlayerID=M".
  static final _playerEntity = RegExp(r'Player EntityID=(\d+) PlayerID=(\d+)');
  final Map<int, int> _entityToPlayer = {};

  GameState? parseLine(String line) {
    // Game mode
    final gtMatch = _gameType.firstMatch(line);
    if (gtMatch != null) {
      final gt = gtMatch.group(1)!;
      _mode = gt.contains('BATTLEGROUNDS') ? GameMode.battlegrounds : GameMode.constructed;
      _log.i('Game mode: $_mode ($gt)');
    }

    // Format (standard / wild)
    final ftMatch = _formatType.firstMatch(line);
    if (ftMatch != null) {
      _format = ftMatch.group(1) == 'WILD' ? 1 : 2;
    }

    // Player name → PlayerID mapping (used to attribute mana, see below).
    final pn = _playerName.firstMatch(line);
    if (pn != null) {
      final pid = int.tryParse(pn.group(1)!);
      final name = pn.group(2)!.trim();
      if (pid != null && name.isNotEmpty && name != 'UNKNOWN HUMAN PLAYER') {
        _nameToPlayer[name] = pid;
      }
    }

    // Player-entity id → PlayerID (so CURRENT_PLAYER on entity 2/3 maps to mine).
    final pe = _playerEntity.firstMatch(line);
    if (pe != null) {
      final eid = int.tryParse(pe.group(1)!);
      final pid = int.tryParse(pe.group(2)!);
      if (eid != null && pid != null) _entityToPlayer[eid] = pid;
    }

    // Mana: RESOURCES / RESOURCES_USED are on the NAMED player entity, not a
    // numeric/bracket id. Resolve the name → PlayerID and only apply MY mana.
    final nr = _namedResource.firstMatch(line);
    if (nr != null) {
      final name = nr.group(1)!;
      final tag = nr.group(2)!;
      final value = int.tryParse(nr.group(3)!) ?? 0;
      final pid = _nameToPlayer[name];
      if (pid != null && pid == _localPlayerId) {
        if (tag == 'RESOURCES') {
          // A rise in my max mana = a new crystal = the start of MY turn.
          // Fallback turn signal for when CURRENT_PLAYER never mapped (e.g. the
          // watcher started mid-session and missed the "Player EntityID" line,
          // leaving _entityToPlayer empty — see _entityToPlayer note).
          if (value > _maxMana && !_currentPlayerMapped) {
            _isPlayerTurn = true;
          }
          _maxMana = value;
        } else {
          _mana = _maxMana - value; // RESOURCES_USED → remaining mana
        }
        return _buildState();
      } else if (pid != null && pid != _localPlayerId && tag == 'RESOURCES') {
        // Opponent's mana refreshed → their turn (only trust as a fallback when
        // CURRENT_PLAYER never gave us a real mapping).
        if (!_currentPlayerMapped) _isPlayerTurn = false;
      }
    }

    // Hero class per player (from any HERO_ cardId seen).
    for (final m in _heroEntity.allMatches(line)) {
      final cls = heroClassFromCardId(m.group(1)!);
      final p = int.tryParse(m.group(2)!);
      if (p != null && cls != 'UNKNOWN') _heroClass[p] = cls;
    }

    // Hero death → that player lost.
    final hd = _heroDeath.firstMatch(line);
    if (hd != null) {
      _losingPlayer = int.tryParse(hd.group(2)!);
    }

    // Game complete → emit a record (once).
    if (!_gameEnded && _gameComplete.hasMatch(line)) {
      _gameEnded = true;
      _emitGameEnd();
    }

    bool changed = false;

    // Mulligan phase boundary. BEGIN_MULLIGAN → opening-hand decisions; the
    // first MAIN_* step ends it (game proper starts).
    final step = _gameStep.firstMatch(line);
    if (step != null) {
      final v = step.group(1)!;
      if (v == 'BEGIN_MULLIGAN') {
        if (!_isMulligan) {
          changed = true;
          _log.i('Mulligan phase START (coin=$_hasCoin)');
        }
        _isMulligan = true;
      } else if (v.startsWith('MAIN')) {
        if (_isMulligan) changed = true;
        _isMulligan = false;
      }
    }

    // Coin = local player going second. THE COIN (GAME_005) entering my hand.
    if (_isMulligan && line.contains('cardId=GAME_005')) {
      final m = _bracket.firstMatch(line);
      if (m != null && int.tryParse(m.group(6)!) == _localPlayerId) {
        if (!_hasCoin) changed = true;
        _hasCoin = true;
      }
    }

    // Parse every bracketed entity — name, zone, zonePos, player all inline.
    for (final m in _bracket.allMatches(line)) {
      final name = m.group(1)!.trim();
      final id = int.parse(m.group(2)!);
      final zone = m.group(3)!;
      final zonePos = int.tryParse(m.group(4)!) ?? 0;
      final cardId = m.group(5) ?? '';
      final player = int.tryParse(m.group(6)!);

      final e = _entities.putIfAbsent(id, () => _Entity(id));
      if (name.isNotEmpty && name != 'UNKNOWN ENTITY') e.name = name;
      if (cardId.isNotEmpty) e.cardId = cardId;
      if (e.zone != zone) changed = true;
      e.zone = zone;
      e.zonePos = zonePos;
      e.player = player;

      // Local player detection: only the local player's own hand cards reveal a
      // cardId while in HAND. Opponent hand cards show cardId= empty. First such
      // card locks the local player id.
      if (_localPlayerId == null &&
          zone == 'HAND' &&
          cardId.isNotEmpty &&
          player != null) {
        _localPlayerId = player;
        _log.i('Local player id detected: $player (via $name $cardId)');
        changed = true;
      }

      // Collection building: any card belonging to the local player with a known
      // cardId is something we own. Fires for game cards, and (when the Zone
      // logger is active) collection-browse / deck-edit cards too.
      if (cardId.isNotEmpty &&
          player != null &&
          (_localPlayerId == null || player == _localPlayerId)) {
        onCardSeen?.call(cardId);
      }
    }

    // TAG_CHANGE ZONE for entities referenced by id only (bracket may not repeat).
    final tb = _tagBracket.firstMatch(line) ?? _tagPlain.firstMatch(line);
    if (tb != null) {
      final id = int.parse(tb.group(1)!);
      final tag = tb.group(2)!;
      final value = tb.group(3)!;
      final e = _entities.putIfAbsent(id, () => _Entity(id));

      switch (tag) {
        case 'ZONE':
          if (e.zone != value) changed = true;
          e.zone = value;
          break;
        // RESOURCES/RESOURCES_USED handled above via named player entity —
        // they never appear on numeric ids, so no case here.
        case 'TURN':
          _turn = int.tryParse(value) ?? _turn;
          break;
        case 'CURRENT_PLAYER':
          // value=1 means THIS player entity is now the active player. Only my
          // turn if that entity maps to my PlayerID.
          if (value == '1') {
            final pid = _entityToPlayer[id];
            if (pid != null) {
              _currentPlayerMapped = true; // real signal — overrides fallback
              final nowMyTurn = pid == _localPlayerId;
              if (nowMyTurn && !_isPlayerTurn) {
                _lastHeroPowerUsed =
                    _heroPowerUsedThisGame; // snapshot turn start
              }
              _isPlayerTurn = nowMyTurn;
              changed = true;
            }
          }
          break;
        // Board minion stats
        case 'ATK':
          e.atk = int.tryParse(value) ?? e.atk;
          changed = true;
          break;
        case 'HEALTH':
          e.health = int.tryParse(value) ?? e.health;
          changed = true;
          break;
        case 'DAMAGE':
          e.damage = int.tryParse(value) ?? e.damage;
          changed = true;
          break;
        case 'TAUNT':
          e.taunt = value == '1';
          changed = true;
          break;
        case 'DIVINE_SHIELD':
          e.divineShield = value == '1';
          break;
        case 'WINDFURY':
          e.windfury = value == '1';
          break;
        case 'STEALTH':
          e.stealth = value == '1';
          break;
        case 'FROZEN':
          e.frozen = value == '1';
          changed = true;
          break;
        case 'RUSH':
          e.rush = value == '1';
          break;
        case 'CHARGE':
          e.charge = value == '1';
          break;
        case 'JUST_PLAYED':
          e.justPlayed = value == '1';
          changed = true;
          break;
        case 'EXHAUSTED':
          e.exhausted = value == '1';
          changed = true;
          break;
        case 'CARDTYPE':
          e.cardType = value;
          break;
        case 'NUM_TIMES_HERO_POWER_USED_THIS_GAME':
          _heroPowerUsedThisGame = int.tryParse(value) ?? _heroPowerUsedThisGame;
          changed = true;
          break;
      }
    }

    if (changed) return _buildState();
    return null;
  }

  GameState? _buildState() {
    _mode ??= GameMode.constructed;
    if (_mode != GameMode.constructed) return null;

    // Hand = named entities in HAND zone. If localPlayerId known, filter by it;
    // else accept all named (non-UNKNOWN) hand cards — opponent cards stay UNKNOWN.
    // Until we know which player is local, don't guess — avoids showing the
    // opponent's revealed/generated cards.
    if (_localPlayerId == null) return null;

    final hand = _entities.values
        .where((e) =>
            e.zone == 'HAND' &&
            e.name != null &&
            e.name!.isNotEmpty &&
            e.player == _localPlayerId)
        .map((e) {
          final meta = e.cardId != null ? cache?.card(e.cardId!) : null;
          return CardInHand(
            cardId: e.cardId ?? e.name!,
            name: meta?.name ?? e.name!,
            cost: meta?.cost ?? 0,
            type: meta?.type ?? CardType.minion,
            rarity: meta?.rarity ?? Rarity.common,
          );
        })
        .toList();

    final opp = _localPlayerId == 1 ? 2 : 1;

    // Board minions: zone=PLAY, zonePos>=1 (zonePos 0 = hero/hero-power/weapon).
    List<MinionOnBoard> minionsFor(int playerId) => _entities.values
        .where((e) =>
            e.zone == 'PLAY' &&
            e.zonePos >= 1 &&
            e.player == playerId &&
            e.name != null &&
            e.name!.isNotEmpty &&
            // skip non-minion play entities (weapons sit at zonePos 0 anyway)
            (e.cardType.isEmpty || e.cardType == 'MINION'))
        .map((e) => MinionOnBoard(
              cardId: e.cardId ?? e.name!,
              name: e.name!,
              attack: e.atk,
              health: e.effectiveHealth,
              isPlayerOwned: playerId == _localPlayerId,
              hasTaunt: e.taunt,
              hasDivineShield: e.divineShield,
              hasWindfury: e.windfury,
              hasStealth: e.stealth,
              canAttack: e.canAttack,
              canAttackFace: e.canAttackFace,
            ))
        .toList();

    // Hero entities (zonePos 0, PLAY) carry hero HP via health - damage.
    int heroHp(int playerId) {
      final hero = _entities.values.firstWhere(
        (e) =>
            e.zone == 'PLAY' &&
            e.player == playerId &&
            (e.cardId?.startsWith('HERO_') ?? false),
        orElse: () => _Entity(-1)..health = 30,
      );
      final hp = hero.health - hero.damage;
      return hp <= 0 ? 30 : hp;
    }

    final board = Board(
      playerMinions: minionsFor(_localPlayerId!),
      opponentMinions: minionsFor(opp),
      playerHp: heroHp(_localPlayerId!),
      opponentHp: heroHp(opp),
    );

    final cls = _heroClass[_localPlayerId!] ?? _playerClass;

    // Equipped weapon (local player, WEAPON cardType in PLAY).
    final weapon = _entities.values.firstWhere(
      (e) =>
          e.zone == 'PLAY' &&
          e.player == _localPlayerId &&
          e.cardType == 'WEAPON',
      orElse: () => _Entity(-1),
    );

    return GameState.constructed(ConstructedState(
      playerClass: cls,
      format: _format == 1 ? ConstructedFormat.wild : ConstructedFormat.standard,
      hand: List.unmodifiable(hand),
      board: board,
      mana: _mana,
      maxMana: _maxMana,
      turn: _turn,
      isPlayerTurn: _isPlayerTurn,
      heroPowerAvailable: _isPlayerTurn && _heroPowerUsedThisGame == _lastHeroPowerUsed,
      weaponAttack: weapon.id == -1 ? 0 : weapon.atk,
      isMulligan: _isMulligan,
      hasCoin: _hasCoin,
    ));
  }

  void _emitGameEnd() {
    final me = _localPlayerId;
    if (me == null) {
      _log.w('Game ended but local player unknown — skipping record');
      return;
    }
    final opp = me == 1 ? 2 : 1;
    // Won if the *other* player's hero died (or my hero did not).
    final won = _losingPlayer != null && _losingPlayer != me;

    final record = GameRecord(
      timestamp: DateTime.now(),
      won: won,
      playerClass: _heroClass[me] ?? 'UNKNOWN',
      opponentClass: _heroClass[opp] ?? 'UNKNOWN',
      mode: _mode == GameMode.battlegrounds ? 'battlegrounds' : 'constructed',
      format: _format == 1 ? 'wild' : (_format == 2 ? 'standard' : ''),
      turns: _turn,
    );
    onGameEnd?.call(record);
  }

  void reset() {
    _entities.clear();
    _heroClass.clear();
    _mode = null;
    _mana = 0;
    _maxMana = 0;
    _turn = 0;
    _localPlayerId = null;
    _gameEnded = false;
    _losingPlayer = null;
    _format = null;
    _heroPowerUsedThisGame = 0;
    _lastHeroPowerUsed = 0;
    _nameToPlayer.clear();
    _entityToPlayer.clear();
    _isPlayerTurn = false;
    _currentPlayerMapped = false;
    _isMulligan = false;
    _hasCoin = false;
  }
}
