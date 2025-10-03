import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/viewmodels/game_viewmodel.dart';

void main() {
  group("GameViewModel", () {
    test("Reset game clears board", () {
      final vm = GameViewModel();
      vm.playerMove(0);
      vm.resetGame();
      expect(vm.board.every((c) => c == ""), true);
    });

    test("Undo removes last move", () async {
      final vm = GameViewModel();
      await vm.playerMove(0);
      vm.undo();
      expect(vm.board[0], "");
    });
  });
}
