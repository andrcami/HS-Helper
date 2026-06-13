import 'dart:convert';
import 'dart:typed_data';

/// Decoded Hearthstone deckstring → list of dbfIds (with repeats for 2-ofs).
/// Deckstring format: base64( reserved byte 0x00, version varint, format varint,
/// then 3 blocks of [count varint][card dbfIds...] for 1-ofs, 2-ofs, n-ofs ).
class DecodedDeck {
  const DecodedDeck({required this.heroDbfId, required this.cards});
  final int heroDbfId;
  final List<int> cards; // dbfIds, repeated by copy count
}

class Deckstring {
  /// Decode a deckstring. Returns null if malformed.
  static DecodedDeck? decode(String code) {
    try {
      final bytes = base64.decode(code.trim());
      final r = _VarReader(bytes);

      if (r.byte() != 0) return null; // reserved
      r.varint(); // version
      r.varint(); // format

      // Heroes
      final heroCount = r.varint();
      int hero = 0;
      for (var i = 0; i < heroCount; i++) {
        final h = r.varint();
        if (i == 0) hero = h;
      }

      final cards = <int>[];

      // 1-of block
      final ones = r.varint();
      for (var i = 0; i < ones; i++) {
        cards.add(r.varint());
      }
      // 2-of block
      final twos = r.varint();
      for (var i = 0; i < twos; i++) {
        final id = r.varint();
        cards..add(id)..add(id);
      }
      // n-of block
      final ns = r.varint();
      for (var i = 0; i < ns; i++) {
        final id = r.varint();
        final n = r.varint();
        for (var j = 0; j < n; j++) {
          cards.add(id);
        }
      }

      return DecodedDeck(heroDbfId: hero, cards: cards);
    } catch (_) {
      return null;
    }
  }
}

class _VarReader {
  _VarReader(this._bytes);
  final Uint8List _bytes;
  int _pos = 0;

  int byte() => _bytes[_pos++];

  /// Read an unsigned LEB128 varint.
  int varint() {
    int result = 0;
    int shift = 0;
    while (true) {
      final b = _bytes[_pos++];
      result |= (b & 0x7f) << shift;
      if ((b & 0x80) == 0) break;
      shift += 7;
    }
    return result;
  }
}
