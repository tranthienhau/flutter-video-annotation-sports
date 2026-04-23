# flutter-live-sports-scores

Flutter POC for a live football score app. Match list, live scores, match details, event timeline, and real-time streaming updates.

## Features

- **Match list**: scheduled, live, finished grouped in single feed with league, teams, scores, and status chip (live minute, FT, or kickoff time)
- **Live updates**: repository exposes `Stream<List<LiveMatch>>`; mock ticks every 3s simulating goals, minute progression, and status transitions - swap for real `http` polling or `WebSocket` without touching UI
- **Match detail**: scoreboard with teams and score, event timeline (goals, cards), status-aware layout
- **Real-time ready**: `ScoreRepository` abstraction accepts any transport (REST polling, SSE, WebSocket) - current impl is in-memory mock

## Stack

Flutter 3.x, Riverpod (StreamProvider), Material 3 dark theme, http, intl.

## Wire to a real API

Drop-in replace `MockScoreRepository` with an HTTP client against API-Football, SportRadar, or LiveScore API. Poll every N seconds or upgrade to WebSocket - the StreamProvider handles rebuilds automatically.

## Run

```
flutter pub get
flutter run
```
