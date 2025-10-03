import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/game_model.dart';
import '../services/ai_service.dart';
import '../utils/sound_service.dart';
import '../utils/storage_service.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class GameViewModel extends ChangeNotifier {
  GameModel model;
  final SoundService soundService = SoundService();
  final AIService aiService;
  final StorageService storageService;
  final FirestoreService firestoreService;
  final AuthService authService;

  Difficulty difficulty;


  int _wins = 0;
  int _losses = 0;
  int _draws = 0;

  Map<String, int> get scores => {
    'wins': _wins,
    'losses': _losses,
    'draws': _draws,
  };

  int get wins => _wins;
  int get losses => _losses;
  int get draws => _draws;

  bool isAiThinking = false;
  Duration aiThinkingDelay = const Duration(milliseconds: 600);

  GameViewModel({
    String humanMark = "X",
    this.difficulty = Difficulty.medium,
    AIService? aiService,
    StorageService? storageService,
    FirestoreService? firestoreService,
    AuthService? authService,
  })  : model = GameModel.newGame(humanMark: humanMark),
        aiService = aiService ?? AIService(),
        storageService = storageService ?? StorageService(),
        firestoreService = firestoreService ?? FirestoreService(),
        authService = authService ?? AuthService() {
    _loadScores();
  }

  List<String> get board => model.board;
  String get currentPlayer => model.currentPlayer;
  String? get winner => model.winner;
  String get humanMark => model.humanMark;
  String get aiMark => model.aiMark;


  void setDifficulty(Difficulty d) {
    difficulty = d;
    aiService.resetMediumCounter();
    resetGame();
  }

  void resetGame({String? humanMark}) {
    model = GameModel.newGame(humanMark: humanMark ?? model.humanMark);
    aiService.resetMediumCounter();
    isAiThinking = false;
    notifyListeners();
  }


  Future<void> playerMove(int idx) async {
    if (isAiThinking) return;
    if (!model.isValidMove(idx)) return;

    soundService.playEffect('assets/sounds/tap.mp3');

    model.makeMove(idx, model.humanMark);
    _evaluateAfterMove(model.humanMark);
    notifyListeners();

    if (model.winner != null || model.boardFull()) return;

    isAiThinking = true;
    notifyListeners();
    await Future.delayed(aiThinkingDelay);

    if (model.winner == null && !model.boardFull()) {
      final aiIdx = aiService.chooseMove(model, difficulty);
      if (model.isValidMove(aiIdx)) {
        model.makeMove(aiIdx, model.aiMark);
        _evaluateAfterMove(model.aiMark);
      }
    }

    isAiThinking = false;
    notifyListeners();
  }

  void _evaluateAfterMove(String mark) {
    if (_checkWinner(mark)) {
      model.setWinner(mark);
      if (mark == model.humanMark) {
        _incrementStat("wins");
        soundService.playEffect('assets/sounds/win.mp3');
      } else {
        _incrementStat("losses");
        soundService.playEffect('assets/sounds/draw.mp3'); // AI win sound
      }
      return;
    }

    if (model.boardFull()) {
      model.setWinner("Draw");
      _incrementStat("draws");
      soundService.playEffect('assets/sounds/draw.mp3');
    }
  }


  void undo() {
    if (isAiThinking) return;
    if (model.moveHistory.isEmpty) return;

    if (model.moveHistory.isNotEmpty && model.board[model.moveHistory.last] == model.aiMark) {
      model.undoLastMove();
    }

    if (model.moveHistory.isNotEmpty && model.board[model.moveHistory.last] == model.humanMark) {
      model.undoLastMove();
    }

    model.winner = null;
    notifyListeners();
  }


  Future<void> _loadScores() async {
    final user = authService.currentUser;
    if (user != null) {
      final data = await firestoreService.getScores(user.uid);
      if (data != null) {
        _wins = _toInt(data['wins']);
        _losses = _toInt(data['losses']);
        _draws = _toInt(data['draws']);
      }
    } else {

      final local = await storageService.readScores();
      _wins = local['wins'] ?? 0;
      _losses = local['losses'] ?? 0;
      _draws = local['draws'] ?? 0;
    }
    notifyListeners();
  }

  Future<void> _incrementStat(String stat) async {
    final user = authService.currentUser;
    if (user != null) {
      await firestoreService.incrementStat(user.uid, stat);
      await _loadScores();
    } else {

      if (stat == "wins") {
        await storageService.incrementWins();
      } else if (stat == "losses") {
        await storageService.incrementLosses();
      } else {
        await storageService.incrementDraws();
      }
      await _loadScores();
    }
  }

  Future<void> resetScores() async {
    final user = authService.currentUser;
    if (user != null) {
      await firestoreService.resetScores(user.uid);
    } else {
      await storageService.resetScores();
    }
    await _loadScores();
  }


  bool _checkWinner(String mark) {
    return _winningPatterns.any((p) => p.every((i) => model.board[i] == mark));
  }

  bool checkWinnerAtIndexForMark(int idx, String mark) {
    return _winningPatterns.any((p) => p.contains(idx) && p.every((i) => model.board[i] == mark));
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  final List<List<int>> _winningPatterns = const [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
}
