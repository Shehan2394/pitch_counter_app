import 'package:flutter/material.dart';
import 'package:pitchcounterapp/notifier/game_notifier.dart';
import 'package:pitchcounterapp/notifier/pitchers_notifier.dart';
import 'package:pitchcounterapp/screens/home.dart';
import 'package:pitchcounterapp/screens/login.dart';
import 'package:provider/provider.dart';

//Pages
import 'notifier/auth_notifier.dart';

void main() => runApp(MultiProvider(
  providers: [
    ChangeNotifierProvider(
    create: (context) => AuthNotifier(),
    ),
    ChangeNotifierProvider(
      create: (context) => PitchersNotifier(),
    ),
    ChangeNotifierProvider(
      create: (context) => GameNotifier(),
    )
  ],
  child: PitchCounterApp(),
));

class PitchCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PitchCounterApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blueAccent,
      ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user != null ? Home() : Login();
          },
      ),
    );
  }
}