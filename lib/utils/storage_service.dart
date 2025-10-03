import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<Map<String, int>> readScores() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'wins': prefs.getInt('wins') ?? 0,
      'losses': prefs.getInt('losses') ?? 0,
      'draws': prefs.getInt('draws') ?? 0,
    };
  }

  Future<void> incrementWins() async {
    final prefs = await SharedPreferences.getInstance();
    final wins = prefs.getInt('wins') ?? 0;
    await prefs.setInt('wins', wins + 1);
  }

  Future<void> incrementLosses() async {
    final prefs = await SharedPreferences.getInstance();
    final losses = prefs.getInt('losses') ?? 0;
    await prefs.setInt('losses', losses + 1);
  }

  Future<void> incrementDraws() async {
    final prefs = await SharedPreferences.getInstance();
    final draws = prefs.getInt('draws') ?? 0;
    await prefs.setInt('draws', draws + 1);
  }

  Future<void> resetScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('wins', 0);
    await prefs.setInt('losses', 0);
    await prefs.setInt('draws', 0);
  }
}
