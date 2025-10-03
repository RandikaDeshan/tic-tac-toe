import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/viewmodels/auth_viewmodel.dart';
import 'package:tic_tac_toe/viewmodels/game_viewmodel.dart';
import 'package:tic_tac_toe/views/auth/splash_screen.dart';
import 'package:tic_tac_toe/wrapper_page.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(
        create: (_) {
          final vm = GameViewModel();
          vm.soundService.startBackground('assets/sounds/bg_music.mp3');
          return vm;
        }),],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tic Tac Toe',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const WrapperPage(),
        ),
    );
  }
}