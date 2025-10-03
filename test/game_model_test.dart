import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/models/game_model.dart';

void main() {
  group("GameModel", () {
    test("New game has empty board", () {
      final game = GameModel.newGame();
      expect(game.board.every((c) => c == ""), true);
    });

    test("Make a move places correct mark", () {
      final game = GameModel.newGame(humanMark: "X");
      game.makeMove(0, "X");
      expect(game.board[0], "X");
    });

    test("Board full after 9 moves", () {
      final game = GameModel.newGame();
      for (int i = 0; i < 9; i++) {
        game.makeMove(i, i % 2 == 0 ? "X" : "O");
      }
      expect(game.boardFull(), true);
    });
  });
}
