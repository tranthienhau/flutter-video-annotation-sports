import 'dart:async';
import 'dart:math';
import '../models/match.dart';

/// Repository abstraction. Real impl would use HTTP or WebSocket
/// (e.g. API-Football, SportRadar, LiveScore API). Mock emits
/// periodic updates to exercise the streaming pipeline.
abstract class ScoreRepository {
  Stream<List<LiveMatch>> watchMatches();
}

class MockScoreRepository implements ScoreRepository {
  final _rng = Random();
  late final List<LiveMatch> _state;

  MockScoreRepository() {
    final now = DateTime.now();
    _state = [
      LiveMatch(
        id: '1',
        league: 'Premier League',
        homeTeam: 'Arsenal',
        awayTeam: 'Man City',
        homeScore: 1,
        awayScore: 1,
        status: MatchStatus.live,
        minute: 58,
        kickoff: now.subtract(const Duration(hours: 1)),
        events: const [
          MatchEvent(minute: 22, type: 'goal', team: 'Arsenal', player: 'Saka'),
          MatchEvent(minute: 41, type: 'goal', team: 'Man City', player: 'Haaland'),
        ],
      ),
      LiveMatch(
        id: '2',
        league: 'La Liga',
        homeTeam: 'Real Madrid',
        awayTeam: 'Barcelona',
        homeScore: 2,
        awayScore: 2,
        status: MatchStatus.live,
        minute: 71,
        kickoff: now.subtract(const Duration(hours: 1)),
      ),
      LiveMatch(
        id: '3',
        league: 'Serie A',
        homeTeam: 'Inter',
        awayTeam: 'Juventus',
        homeScore: 0,
        awayScore: 0,
        status: MatchStatus.scheduled,
        minute: 0,
        kickoff: now.add(const Duration(hours: 2)),
      ),
      LiveMatch(
        id: '4',
        league: 'Bundesliga',
        homeTeam: 'Bayern',
        awayTeam: 'Dortmund',
        homeScore: 3,
        awayScore: 1,
        status: MatchStatus.finished,
        minute: 90,
        kickoff: now.subtract(const Duration(hours: 3)),
      ),
    ];
  }

  @override
  Stream<List<LiveMatch>> watchMatches() async* {
    yield _state;
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      _tick();
      yield List.unmodifiable(_state);
    }
  }

  void _tick() {
    for (int i = 0; i < _state.length; i++) {
      final m = _state[i];
      if (m.status != MatchStatus.live) continue;
      final scoreBump = _rng.nextInt(20) == 0;
      final homeGoal = scoreBump && _rng.nextBool();
      final newMinute = (m.minute + 1).clamp(0, 95);
      final newStatus = newMinute >= 90 ? MatchStatus.finished : m.status;
      _state[i] = m.copyWith(
        minute: newMinute,
        status: newStatus,
        homeScore: homeGoal ? m.homeScore + 1 : m.homeScore,
        awayScore: scoreBump && !homeGoal ? m.awayScore + 1 : m.awayScore,
        events: scoreBump
            ? [
                ...m.events,
                MatchEvent(
                  minute: newMinute,
                  type: 'goal',
                  team: homeGoal ? m.homeTeam : m.awayTeam,
                  player: 'Scorer',
                ),
              ]
            : m.events,
      );
    }
  }
}
