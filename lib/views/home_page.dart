import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/views/auth/login_screen.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'game_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await vm.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return LoginScreen();
              },));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Welcome to Tic Tac Toe!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),


              const Text(
                "🎮 How to Play",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const Text(
                "1. The game is played on a 3x3 grid.\n"
                    "2. You are X, and the AI is O.\n"
                    "3. Players take turns placing marks in empty squares.\n"
                    "4. First to get 3 in a row (horizontally, vertically, or diagonally) wins.\n"
                    "5. If all squares are filled and no one wins, the game is a draw.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),

              const SizedBox(height: 30),


              const Text(
                "⚙️ Game Modes",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Easy 😴",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text("• AI plays random moves.\n• Suitable for beginners."),
                    SizedBox(height: 12),
                    Text(
                      "Medium 🙂",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text("• AI plays smarter but still makes mistakes.\n• Balanced challenge."),
                    SizedBox(height: 12),
                    Text(
                      "Hard 😈",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text("• AI uses strategy to block and win.\n• Very hard to defeat!"),
                  ],
                ),
              ),

              const SizedBox(height: 40),


              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameView()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF4866F0),
                  minimumSize: Size(MediaQuery.of(context).size.width, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Start Game",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}