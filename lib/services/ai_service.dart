import 'dart:math';
import '../models/game_model.dart';

enum Difficulty { easy, medium, hard }

class AIService {
  final Random _rand = Random();
  int _mediumTurnCounter = 0;

  int chooseMove(GameModel model, Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return _chooseRandom(model);

      case Difficulty.medium:
        _mediumTurnCounter++;
        if (_mediumTurnCounter % 2 == 1) {
          return _chooseRandom(model);
        } else {
          return _chooseHard(model);
        }

      case Difficulty.hard:
        return _chooseHard(model);
    }
  }

  void resetMediumCounter() {
    _mediumTurnCounter = 0;
  }

  int _chooseRandom(GameModel model) {
    final empties = _getEmptySquares(model);
    return empties[_rand.nextInt(empties.length)];
  }

  int _chooseHard(GameModel model) {
    final myMark = model.aiMark;
    final oppMark = model.humanMark;

    final winMove = _findWinningMove(model, myMark);
    if (winMove != null) return winMove;

    final blockMove = _findWinningMove(model, oppMark);
    if (blockMove != null) return blockMove;

    final forkMove = _findForkMove(model, myMark);
    if (forkMove != null) return forkMove;

    final blockFork = _findForkMove(model, oppMark);
    if (blockFork != null) return blockFork;

    if (model.board[4] == "") return 4;

    final oppositeCorner = _takeOppositeCorner(model, oppMark);
    if (oppositeCorner != null) return oppositeCorner;

    final corners = [0, 2, 6, 8];
    final freeCorners = corners.where((c) => model.board[c] == "").toList();
    if (freeCorners.isNotEmpty) {
      return freeCorners[_rand.nextInt(freeCorners.length)];
    }

    final empties = _getEmptySquares(model);
    return empties[_rand.nextInt(empties.length)];
  }

  List<int> _getEmptySquares(GameModel model) {
    final empties = <int>[];
    for (int i = 0; i < 9; i++) {
      if (model.board[i] == "") empties.add(i);
    }
    return empties;
  }

  int? _findWinningMove(GameModel model, String mark) {
    for (var pattern in _winningPatterns) {
      final cells = pattern.map((i) => model.board[i]).toList();
      if (cells.where((c) => c == mark).length == 2 && cells.contains("")) {
        return pattern[cells.indexOf("")];
      }
    }
    return null;
  }

  int? _findForkMove(GameModel model, String mark) {
    final empties = _getEmptySquares(model);
    for (var idx in empties) {
      final testBoard = List<String>.from(model.board);
      testBoard[idx] = mark;

      int winChances = 0;
      for (var pattern in _winningPatterns) {
        final cells = pattern.map((i) => testBoard[i]).toList();
        if (cells.where((c) => c == mark).length == 2 && cells.contains("")) {
          winChances++;
        }
      }
      if (winChances >= 2) return idx;
    }
    return null;
  }

  int? _takeOppositeCorner(GameModel model, String oppMark) {
    final opposites = {0: 8, 2: 6, 6: 2, 8: 0};
    for (var entry in opposites.entries) {
      if (model.board[entry.key] == oppMark && model.board[entry.value] == "") {
        return entry.value;
      }
    }
    return null;
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
