class GameModel {
  List<String> board;
  String currentPlayer;
  String? winner;
  final String humanMark;
  final String aiMark;
  List<int> moveHistory = [];

  GameModel._({
    required this.board,
    required this.currentPlayer,
    required this.humanMark,
    required this.aiMark,
    this.winner,
  });

  factory GameModel.newGame({String humanMark = "X"}) {
    return GameModel._(
      board: List.filled(9, ""),
      currentPlayer: "X",
      humanMark: humanMark,
      aiMark: humanMark == "X" ? "O" : "X",
    );
  }

  bool isValidMove(int idx) => board[idx] == "" && winner == null;

  void makeMove(int idx, String mark) {
    if (board[idx] == "") {
      board[idx] = mark;
      moveHistory.add(idx);
      currentPlayer = (mark == "X") ? "O" : "X";
    }
  }

  void undoLastMove() {
    if (moveHistory.isNotEmpty) {
      final lastIdx = moveHistory.removeLast();
      board[lastIdx] = "";
      currentPlayer = (currentPlayer == "X") ? "O" : "X";
    }
  }

  bool boardFull() => !board.contains("");

  void setWinner(String mark) {
    winner = mark;
  }
}
