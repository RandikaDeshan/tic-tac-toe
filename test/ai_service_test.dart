import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/models/game_model.dart';
import 'package:tic_tac_toe/services/ai_service.dart';

void main() {
  group("AIService", () {
    test("Easy mode picks valid empty cell", () {
      final ai = AIService();
      final game = GameModel.newGame(humanMark: "X");
      final move = ai.chooseMove(game, Difficulty.easy);
      expect(game.isValidMove(move), true);
    });

    test("Hard mode blocks opponent winning move", () {
      final ai = AIService();
      final game = GameModel.newGame(humanMark: "X");
      game.makeMove(0, "X");
      game.makeMove(1, "X");
      final move = ai.chooseMove(game, Difficulty.hard);
      expect(move, 2);
    });
  });
}
