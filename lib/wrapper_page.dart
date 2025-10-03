import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/views/auth/splash_screen.dart';
import 'package:tic_tac_toe/views/game_view.dart';
import 'package:tic_tac_toe/views/home_page.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }else if(snapshot.hasData){
        return HomePage();
      }
      else{
        return SplashScreen();
      }
    },);
  }
}
