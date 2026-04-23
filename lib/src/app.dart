import 'package:flutter/material.dart';
import 'features/matches/match_list_screen.dart';

class LiveScoresApp extends StatelessWidget {
  const LiveScoresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Scores',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1419),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF22C55E),
          surface: Color(0xFF1A1F29),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1A1F29),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F1419),
          elevation: 0,
        ),
      ),
      home: const MatchListScreen(),
    );
  }
}
