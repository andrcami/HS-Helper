/// Keyword-driven combat simulator models.
///
/// This is NOT a full card-effect engine — no data source provides executable
/// scripts for the ~5000 unique card texts. Instead it simulates everything the
/// KEYWORDS define (combat, divine shield, freeze, poison, lifesteal, taunt,
/// rush/charge, windfury, reborn, spell damage). Battlecry/deathrattle are
/// flagged as "present" so scoring can hedge, but their specific effects are
/// unknown unless added to a curated script table later.

/// Keywords we model. Parsed from HearthstoneJSON `mechanics`.
enum Keyword {
  taunt,
  divineShield,
  windfury,
  rush,
  charge,
  lifesteal,
  poisonous,
  reborn,
  stealth,
  frozen,
  cantAttack,
  battlecry, // effect unknown — flag only
  deathrattle, // effect unknown — flag only
  spellDamage,
}

class SimMinion {
  SimMinion({
    required this.cardId,
    required this.name,
    required this.attack,
    required this.health,
    required this.isPlayerOwned,
    Set<Keyword>? keywords,
    this.maxHealth = 0,
    this.canAttack = true,
    this.canAttackFace = true,
    this.spellDamage = 0,
  }) : keywords = keywords ?? <Keyword>{} {
    if (maxHealth == 0) maxHealth = health;
  }

  final String cardId;
  final String name;
  int attack;
  int health;
  int maxHealth;
  final bool isPlayerOwned;
  final Set<Keyword> keywords;
  bool canAttack; // summoning sickness / exhausted / frozen handled here
  bool canAttackFace; // false for rush played this turn
  int spellDamage;

  bool has(Keyword k) => keywords.contains(k);
  bool get alive => health > 0;

  SimMinion clone() => SimMinion(
        cardId: cardId,
        name: name,
        attack: attack,
        health: health,
        maxHealth: maxHealth,
        isPlayerOwned: isPlayerOwned,
        keywords: {...keywords},
        canAttack: canAttack,
        canAttackFace: canAttackFace,
        spellDamage: spellDamage,
      );
}

class SimBoard {
  SimBoard({
    required this.playerMinions,
    required this.opponentMinions,
    required this.playerHp,
    required this.opponentHp,
    this.playerArmor = 0,
    this.opponentArmor = 0,
  });

  List<SimMinion> playerMinions;
  List<SimMinion> opponentMinions;
  int playerHp;
  int opponentHp;
  int playerArmor;
  int opponentArmor;

  SimBoard clone() => SimBoard(
        playerMinions: playerMinions.map((m) => m.clone()).toList(),
        opponentMinions: opponentMinions.map((m) => m.clone()).toList(),
        playerHp: playerHp,
        opponentHp: opponentHp,
        playerArmor: playerArmor,
        opponentArmor: opponentArmor,
      );

  List<SimMinion> minionsOf(bool player) =>
      player ? playerMinions : opponentMinions;

  /// Taunts on a side — attackers must hit these first.
  List<SimMinion> taunts(bool player) =>
      minionsOf(player).where((m) => m.has(Keyword.taunt) && m.alive).toList();

  void removeDead() {
    playerMinions.removeWhere((m) => !m.alive);
    opponentMinions.removeWhere((m) => !m.alive);
  }
}
