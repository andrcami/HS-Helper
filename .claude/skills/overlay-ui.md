# Overlay UI Skill

## flutter_overlay_window Setup

### Android
```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>
```
```dart
await FlutterOverlayWindow.showOverlay(
  enableDrag: true,
  overlayTitle: "HS Advisor",
  overlayContent: "Active",
  flag: OverlayFlag.clickThrough,  // pass clicks to game
  visibility: NotificationVisibility.visibilityPublic,
  positionGravity: PositionGravity.auto,
  width: 300,
  height: 400,
);
```

### Windows
Use `window_manager` package for topmost transparent window:
```dart
await windowManager.setAlwaysOnTop(true);
await windowManager.setSkipTaskbar(true);
await windowManager.setBackgroundColor(Colors.transparent);
// Position over Hearthstone window
```

## Recommendation Card Widget
```dart
// Small pill showing card name + % 
// Tapping expands to show reason text
RecommendationPill(
  cardName: "Fireball",
  score: 0.82,       // shows as "82%"
  isLethal: false,
  color: Colors.green,
)
```

## Layout
```
┌─────────────────────────┐
│  HS Advisor  [Refresh]  │
├─────────────────────────┤
│ 1. Fireball      82% →  │
│ 2. Mage Armor    61% →  │
│ 3. Frostbolt     44% →  │
├─────────────────────────┤
│ Data: 2026-06-05  [↻]   │
└─────────────────────────┘
```

## Click-through
- Overlay background: click-through (passes to game)
- Buttons only: intercept clicks
- `OverlayFlag.clickThrough` on Android
- Windows: `SetWindowLong(hwnd, GWL_EXSTYLE, WS_EX_TRANSPARENT)` via win32

## Theming
- Dark semi-transparent background: `Colors.black.withOpacity(0.75)`
- Hearthstone gold accent: `Color(0xFFD4A017)`
- Font: system default (no custom fonts — keep overlay lightweight)
