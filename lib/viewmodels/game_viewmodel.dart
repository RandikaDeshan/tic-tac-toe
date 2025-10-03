import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../services/ai_service.dart';
import '../utils/sound_service.dart';
import '../utils/storage_service.dart';

class GameViewModel extends ChangeNotifier {
  GameModel model;
  final SoundService soundService = SoundService();
  final AIService aiService;
  final StorageService storageService;
  Difficulty difficulty;
  Map<String, int> scores = {'wins': 0, 'losses': 0, 'draws': 0};

  /// Public property for UI to read/disable input
  bool isAiThinking = false;

  /// Optional: how long AI "thinks" (simulate)
  Duration aiThinkingDelay = const Duration(milliseconds: 600);

  GameViewModel({
    String humanMark = "X",
    this.difficulty = Difficulty.medium,
    AIService? aiService,
    StorageService? storageService,
  })  : model = GameModel.newGame(humanMark: humanMark),
        aiService = aiService ?? AIService(),
        storageService = storageService ?? StorageService() {
    _loadScores();
  }

  // --- getters used by UI ---
  List<String> get board => model.board;
  String get currentPlayer => model.currentPlayer;
  String? get winner => model.winner;
  String get humanMark => model.humanMark;
  String get aiMark => model.aiMark;

  // --- game setup ---
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


  bool _checkWinner(String mark) {
    return _winningPatterns.any((p) => p.every((i) => model.board[i] == mark));
  }

  // Public helper to let the UI highlight winning tiles
  bool checkWinnerAtIndexForMark(int idx, String mark) {
    return _winningPatterns.any((p) => p.contains(idx) && p.every((i) => model.board[i] == mark));
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

  // --- undo (disabled while AI thinking) ---
  void undo() {
    if (isAiThinking) return;
    if (model.moveHistory.isEmpty) return;

    // remove AI move if last move was AI
    if (model.moveHistory.isNotEmpty && model.board[model.moveHistory.last] == model.aiMark) {
      model.undoLastMove();
    }

    // remove human move if last move was human
    if (model.moveHistory.isNotEmpty && model.board[model.moveHistory.last] == model.humanMark) {
      model.undoLastMove();
    }

    model.winner = null;
    notifyListeners();
  }

  // --- persistence ---
  Future<void> _loadScores() async {
    scores = await storageService.readScores();
    notifyListeners();
  }

  Future<void> resetScores() async {
    await storageService.resetScores();
    await _loadScores();
  }

  Future<void> playerMove(int idx) async {
    if (isAiThinking) return;
    if (!model.isValidMove(idx)) return;

    // Play tap sound
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
        storageService.incrementWins().then((_) => _loadScores());
        soundService.playEffect('assets/sounds/win.mp3');
      } else {
        storageService.incrementLosses().then((_) => _loadScores());
        soundService.playEffect('assets/sounds/draw.mp3'); // AI win
      }
      return;
    }
    if (model.boardFull()) {
      model.setWinner("Draw");
      storageService.incrementDraws().then((_) => _loadScores());
      soundService.playEffect('assets/sounds/draw.mp3');
    }
  }

}
