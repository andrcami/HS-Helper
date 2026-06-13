/// Heuristic extraction of a card's likely effect from its English text +
/// mechanic tags. NOT a real effect engine (the data wall — see [[simulator]]);
/// it recognizes common PATTERNS so the engine can score a card against the
/// current board instead of treating every card identically.
class CardEffectHints {
  CardEffectHints({
    this.damage = 0,
    this.isAoe = false,
    this.hitsAllMinions = false,
    this.heal = 0,
    this.armor = 0,
    this.drawCount = 0,
    this.buffAttack = 0,
    this.buffHealth = 0,
    this.buffsBoard = false,
    this.summonCount = 0,
    this.isRemoval = false,
    this.givesTaunt = false,
  });

  final int damage; // single-target / per-target damage
  final bool isAoe; // affects multiple targets
  final bool hitsAllMinions; // board clear (both sides) risk
  final int heal;
  final int armor;
  final int drawCount;
  final int buffAttack;
  final int buffHealth;
  final bool buffsBoard; // buff that wants friendly minions present
  final int summonCount;
  final bool isRemoval; // destroy / transform / silence-to-remove
  final bool givesTaunt;

  static final _damage = RegExp(r'deal \$?(\d+)\s+damage', caseSensitive: false);
  static final _heal = RegExp(r'restore \$?(\d+)\s+health', caseSensitive: false);
  static final _armor = RegExp(r'gain (\d+) armor', caseSensitive: false);
  static final _draw = RegExp(r'draw (a|\d+) cards?', caseSensitive: false);
  static final _buff = RegExp(r'give[^.]*?\+(\d+)/\+(\d+)', caseSensitive: false);
  static final _buffSelf = RegExp(r'\+(\d+)/\+(\d+)', caseSensitive: false);
  static final _summon = RegExp(r'summon (a|an|\d+|two|three)', caseSensitive: false);

  static int _word(String w) {
    switch (w.toLowerCase()) {
      case 'a':
      case 'an':
      case 'one':
        return 1;
      case 'two':
        return 2;
      case 'three':
        return 3;
      default:
        return int.tryParse(w) ?? 1;
    }
  }

  /// Parse hints from text + mechanic tags.
  factory CardEffectHints.parse(String text, List<String> mechanics) {
    final t = text.toLowerCase();
    final mech = mechanics.map((m) => m.toUpperCase()).toSet();

    int damage = 0;
    final dm = _damage.firstMatch(t);
    if (dm != null) damage = int.tryParse(dm.group(1)!) ?? 0;

    final hitsAll = t.contains('all minions') ||
        t.contains('all enemy minions') ||
        t.contains('all other minions');
    final aoe = hitsAll ||
        t.contains('all enemies') ||
        t.contains('adjacent') ||
        (damage > 0 && t.contains('all'));

    int heal = 0;
    final hm = _heal.firstMatch(t);
    if (hm != null) heal = int.tryParse(hm.group(1)!) ?? 0;

    int armor = 0;
    final am = _armor.firstMatch(t);
    if (am != null) armor = int.tryParse(am.group(1)!) ?? 0;

    int draw = 0;
    final drm = _draw.firstMatch(t);
    if (drm != null) draw = _word(drm.group(1)!);

    int bAtk = 0, bHp = 0;
    bool buffsBoard = false;
    final bm = _buff.firstMatch(t);
    if (bm != null) {
      bAtk = int.tryParse(bm.group(1)!) ?? 0;
      bHp = int.tryParse(bm.group(2)!) ?? 0;
      buffsBoard = t.contains('friendly') ||
          t.contains('your minions') ||
          t.contains('a minion');
    } else if (t.contains('give') && _buffSelf.hasMatch(t)) {
      final sm = _buffSelf.firstMatch(t)!;
      bAtk = int.tryParse(sm.group(1)!) ?? 0;
      bHp = int.tryParse(sm.group(2)!) ?? 0;
      buffsBoard = true;
    }

    int summon = 0;
    final smn = _summon.firstMatch(t);
    if (smn != null) summon = _word(smn.group(1)!);

    final removal = t.contains('destroy') ||
        t.contains('transform') ||
        (t.contains('silence') && t.contains('minion')) ||
        (damage > 0 && !aoe); // single-target damage doubles as removal

    final givesTaunt = mech.contains('TAUNT') || t.contains('gain taunt');

    return CardEffectHints(
      damage: damage,
      isAoe: aoe,
      hitsAllMinions: hitsAll,
      heal: heal,
      armor: armor,
      drawCount: draw,
      buffAttack: bAtk,
      buffHealth: bHp,
      buffsBoard: buffsBoard,
      summonCount: summon,
      isRemoval: removal,
      givesTaunt: givesTaunt,
    );
  }

  bool get hasAnyEffect =>
      damage > 0 ||
      heal > 0 ||
      armor > 0 ||
      drawCount > 0 ||
      buffAttack > 0 ||
      buffHealth > 0 ||
      summonCount > 0 ||
      isRemoval ||
      givesTaunt;
}
