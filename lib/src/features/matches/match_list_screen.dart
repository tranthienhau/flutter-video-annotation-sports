import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/match.dart';
import 'providers.dart';
import 'match_detail_screen.dart';

class MatchListScreen extends ConsumerWidget {
  const MatchListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(matchesStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Football Live'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(matchesStreamProvider),
          ),
        ],
      ),
      body: async.when(
        data: (matches) => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: matches.length,
          itemBuilder: (_, i) => _MatchCard(match: matches[i]),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final LiveMatch match;
  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => MatchDetailScreen(matchId: match.id),
        )),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(match.league, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                  const Spacer(),
                  _StatusChip(match: match),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(match.homeTeam,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  Text('${match.homeScore}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(match.awayTeam,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  Text('${match.awayScore}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final LiveMatch match;
  const _StatusChip({required this.match});

  @override
  Widget build(BuildContext context) {
    switch (match.status) {
      case MatchStatus.live:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(radius: 4, backgroundColor: Color(0xFFEF4444)),
            const SizedBox(width: 6),
            Text('${match.minute}\'', style: const TextStyle(color: Color(0xFFEF4444))),
          ],
        );
      case MatchStatus.finished:
        return const Text('FT', style: TextStyle(color: Colors.white54));
      case MatchStatus.scheduled:
        final t = match.kickoff;
        return Text('${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(color: Colors.white54));
    }
  }
}
