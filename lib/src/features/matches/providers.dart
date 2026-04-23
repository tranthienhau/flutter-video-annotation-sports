import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/score_repository.dart';
import '../../models/match.dart';

final scoreRepositoryProvider = Provider<ScoreRepository>((ref) => MockScoreRepository());

final matchesStreamProvider = StreamProvider<List<LiveMatch>>((ref) {
  return ref.watch(scoreRepositoryProvider).watchMatches();
});
