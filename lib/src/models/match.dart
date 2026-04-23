enum MatchStatus { scheduled, live, finished }

class MatchEvent {
  final int minute;
  final String type;
  final String team;
  final String player;
  const MatchEvent({
    required this.minute,
    required this.type,
    required this.team,
    required this.player,
  });
}

class LiveMatch {
  final String id;
  final String league;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final MatchStatus status;
  final int minute;
  final DateTime kickoff;
  final List<MatchEvent> events;

  const LiveMatch({
    required this.id,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.status,
    required this.minute,
    required this.kickoff,
    this.events = const [],
  });

  LiveMatch copyWith({
    int? homeScore,
    int? awayScore,
    MatchStatus? status,
    int? minute,
    List<MatchEvent>? events,
  }) =>
      LiveMatch(
        id: id,
        league: league,
        homeTeam: homeTeam,
        awayTeam: awayTeam,
        homeScore: homeScore ?? this.homeScore,
        awayScore: awayScore ?? this.awayScore,
        status: status ?? this.status,
        minute: minute ?? this.minute,
        kickoff: kickoff,
        events: events ?? this.events,
      );
}
