import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/match.dart';
import 'providers.dart';

class MatchDetailScreen extends ConsumerWidget {
  final String matchId;
  const MatchDetailScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(matchesStreamProvider);
    final match = async.maybeWhen(
      data: (list) => list.firstWhere((m) => m.id == matchId),
      orElse: () => null,
    );
    if (match == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text(match.league)),
      body: Column(
        children: [
          _Scoreboard(match: match),
          const Divider(height: 1),
          Expanded(
            child: match.events.isEmpty
                ? const Center(child: Text('No events yet', style: TextStyle(color: Colors.white54)))
                : ListView.builder(
                    itemCount: match.events.length,
                    itemBuilder: (_, i) => _EventTile(event: match.events[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Scoreboard extends StatelessWidget {
  final LiveMatch match;
  const _Scoreboard({required this.match});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.sports_soccer, size: 40),
                const SizedBox(height: 8),
                Text(match.homeTeam, textAlign: TextAlign.center),
              ],
            ),
          ),
          Column(
            children: [
              Text('${match.homeScore} - ${match.awayScore}',
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(
                match.status == MatchStatus.live ? '${match.minute}\'' : match.status.name,
                style: const TextStyle(color: Color(0xFF22C55E)),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.sports_soccer, size: 40),
                const SizedBox(height: 8),
                Text(match.awayTeam, textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final MatchEvent event;
  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white10,
        child: Text('${event.minute}\'', style: const TextStyle(fontSize: 12)),
      ),
      title: Text('${event.type.toUpperCase()} - ${event.player}'),
      subtitle: Text(event.team),
    );
  }
}
