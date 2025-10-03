import 'package:flutter/material.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 5));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome",style: TextStyle(fontSize: 33,fontWeight: FontWeight.bold,color: Colors.blue.shade800),),
            Text("Tic Tac Toe",style: TextStyle(fontSize: 45,fontWeight: FontWeight.bold),),
            Text("X  |  O  |  X",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color: Colors.blue.shade800),),
          ],
        ),
      ),
    );
  }
}
