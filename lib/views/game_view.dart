import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../viewmodels/game_viewmodel.dart';
import '../services/ai_service.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late ConfettiController _confettiCtrl;

  @override
  void initState() {
    super.initState();
    _confettiCtrl = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GameViewModel>(context);


    if (vm.winner != null && vm.winner == vm.humanMark) {
      _confettiCtrl.play();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'easy') vm.setDifficulty(Difficulty.easy);
              if (value == 'medium') vm.setDifficulty(Difficulty.medium);
              if (value == 'hard') vm.setDifficulty(Difficulty.hard);
              if (value == 'reset_scores') vm.resetScores();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'easy', child: Text("Easy")),
              const PopupMenuItem(value: 'medium', child: Text("Medium")),
              const PopupMenuItem(value: 'hard', child: Text("Hard")),
              const PopupMenuItem(value: 'reset_scores', child: Text("Reset Scores")),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              _buildScoreboard(vm),   // ✅ Scoreboard on top
              const SizedBox(height: 20),
              _buildBoard(vm),        // ✅ Game board
              const SizedBox(height: 20),
              _buildControls(vm),     // ✅ Controls
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiCtrl,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 25,
              gravity: 0.3,
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildScoreboard(GameViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _scoreCard("Wins", vm.wins, Colors.green),
        _scoreCard("Losses", vm.losses, Colors.red),
        _scoreCard("Draws", vm.draws, Colors.orange),
      ],
    );
  }

  Widget _scoreCard(String title, int value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 6),
            Text(value.toString(), style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }


  Widget _buildBoard(GameViewModel vm) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: 9,
        itemBuilder: (context, i) {
          final mark = vm.board[i];
          final isWinningTile = vm.winner != null &&
              vm.checkWinnerAtIndexForMark(i, vm.winner!);

          return GestureDetector(
            onTap: () {
              if (!vm.isAiThinking && vm.model.isValidMove(i)) {
                vm.playerMove(i);
              }
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isWinningTile ? Colors.yellowAccent : Colors.white,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Center(
                child: Text(
                  mark,
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: mark == vm.humanMark ? Colors.blue : Colors.red,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControls(GameViewModel vm) {
    return Column(
      children: [
        Text(
          vm.winner == null
              ? (vm.isAiThinking ? "AI is thinking..." : "Your turn")
              : (vm.winner == "Draw" ? "It's a Draw!" : "${vm.winner} Wins!"),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: vm.resetGame, child: const Text("New Game")),
            ElevatedButton(
              onPressed: (!vm.isAiThinking && vm.model.moveHistory.isNotEmpty)
                  ? vm.undo
                  : null,
              child: const Text("Undo"),
            ),
          ],
        )
      ],
    );
  }
}
