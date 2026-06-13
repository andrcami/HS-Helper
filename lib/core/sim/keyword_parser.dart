import '../game_state.dart';
import '../../data/cache_manager.dart';
import 'sim_models.dart';

/// Maps HearthstoneJSON `mechanics` strings → our Keyword enum, and builds a
/// SimBoard from the live ConstructedState + card DB.
class KeywordParser {
  KeywordParser(this.cache);
  final CacheManager cache;

  static Keyword? _fromMechanic(String m) {
    switch (m) {
      case 'TAUNT':
        return Keyword.taunt;
      case 'DIVINE_SHIELD':
        return Keyword.divineShield;
      case 'WINDFURY':
        return Keyword.windfury;
      case 'RUSH':
        return Keyword.rush;
      case 'CHARGE':
        return Keyword.charge;
      case 'LIFESTEAL':
        return Keyword.lifesteal;
      case 'POISONOUS':
        return Keyword.poisonous;
      case 'REBORN':
        return Keyword.reborn;
      case 'STEALTH':
        return Keyword.stealth;
      case 'FREEZE':
        return Keyword.frozen;
      case 'BATTLECRY':
        return Keyword.battlecry;
      case 'DEATHRATTLE':
        return Keyword.deathrattle;
      case 'SPELLPOWER':
      case 'SPELLBURST':
        return Keyword.spellDamage;
      default:
        return null; // mechanic not modeled in combat sim
    }
  }

  /// Keyword set for a cardId, from its DB mechanics.
  Set<Keyword> keywordsFor(String cardId) {
    final meta = cache.card(cardId);
    if (meta == null) return {};
    // CardMeta currently exposes name/cost/type/rarity/class/text — mechanics
    // are not stored yet, so derive what we can from text as a fallback.
    // (mechanics wired in CacheManager — see cardMechanics().)
    return cache.cardMechanics(cardId).map(_fromMechanic).whereType<Keyword>().toSet();
  }

  SimMinion _toSim(MinionOnBoard m) {
    final kws = keywordsFor(m.cardId);
    if (m.hasTaunt) kws.add(Keyword.taunt);
    if (m.hasDivineShield) kws.add(Keyword.divineShield);
    if (m.hasWindfury) kws.add(Keyword.windfury);
    return SimMinion(
      cardId: m.cardId,
      name: m.name,
      attack: m.attack,
      health: m.health,
      isPlayerOwned: m.isPlayerOwned,
      keywords: kws,
      canAttack: true, // refined by EXHAUSTED tracking later
    );
  }

  SimBoard fromState(ConstructedState s) {
    return SimBoard(
      playerMinions: s.board.playerMinions.map(_toSim).toList(),
      opponentMinions: s.board.opponentMinions.map(_toSim).toList(),
      playerHp: s.board.playerHp,
      opponentHp: s.board.opponentHp,
    );
  }
}
