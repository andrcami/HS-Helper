/// Maps a Hearthstone HERO_ cardId to a class name.
/// Base hero cardIds: HERO_01..HERO_11 (+ skin suffixes like HERO_01a).
String heroClassFromCardId(String cardId) {
  // Strip skin/variant suffix: HERO_01a -> HERO_01, HERO_11bp -> HERO_11.
  final m = RegExp(r'HERO_(\d{2})').firstMatch(cardId);
  if (m == null) return 'UNKNOWN';
  switch (m.group(1)) {
    case '01':
      return 'Warrior';
    case '02':
      return 'Shaman';
    case '03':
      return 'Rogue';
    case '04':
      return 'Paladin';
    case '05':
      return 'Hunter';
    case '06':
      return 'Druid';
    case '07':
      return 'Warlock';
    case '08':
      return 'Mage';
    case '09':
      return 'Priest';
    case '10':
      return 'Demon Hunter';
    case '11':
      return 'Death Knight';
    default:
      return 'UNKNOWN';
  }
}
