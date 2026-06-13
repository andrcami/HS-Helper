# Recommendation Engine Skill

## Scoring Formula

### Constructed
```
final_score = base_score * context_multipliers

base_score = hsreplay_winrate (0.0–1.0)

context_multipliers:
  - mana_efficiency: (card_cost / available_mana).clamp(0.5, 1.0)
  - board_pressure: if opponent_minions > 2 && card_has_taunt → 1.2
  - lethal_check: if card_damage >= opponent_hp → 10.0 (always recommend)
  - personal_adjustment: lerp(1.0, personal_winrate/hsreplay_winrate, personal_weight)

personal_weight = min(personal_game_count / 200, 0.3)
```

### Battlegrounds Shop Phase
```
buy_score = tier_list_score * econ_factor

tier_list_score = firestone_tier (1=best, 6=worst) → normalized to 0.0–1.0
econ_factor:
  - if upgrade_tavern_better_than_buy → recommend upgrade instead
  - freeze_value: if top_3_minions_unsold → freeze score boost
  - triple_check: if 2 of card exist on board → buy score * 1.5
```

## Output Format
```dart
class Recommendation {
  final CardInHand card;
  final double score;       // 0.0–1.0
  final String reason;      // "High winrate + mana efficient"
  final bool isLethal;
}

// Always return top 3, sorted by score desc
List<Recommendation> topPlays(GameState state);
```

## Overlay Display
- Show card name + score as percentage
- Color: green >70%, yellow 40–70%, red <40%
- Lethal: always show "LETHAL" banner regardless of score

## BGS Attack Order (combat phase)
- Pre-combat: suggest minion positioning
- Rule: divine shield first, then highest attack, taunt last
- This is heuristic only — no API data available

## Personal Learning
```
After each game store:
  - cards_played: List<{card_id, turn, board_state_hash}>
  - outcome: win | loss
  - final_rank (BGS) or opponent_final_hp (Constructed)

Query for personal_winrate:
  SELECT AVG(outcome='win') FROM games
  JOIN cards_played USING(game_id)
  WHERE card_id = ? AND game_count > 20
```
