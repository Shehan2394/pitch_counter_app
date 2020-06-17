import 'package:flutter/material.dart';
import 'package:pitchcounterapp/notifier/game_notifier.dart';
import 'package:provider/provider.dart';

class GameDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GameNotifier gameNotifier = Provider.of<GameNotifier>(context,listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text(gameNotifier.currentGame.name,
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Bangers',
              color: Colors.white,
            ),),
        ),
        body: Center(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(0,50,0,0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/baseball5.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                Text(gameNotifier.currentGame.number,
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Bangers',
                      color: Colors.white
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}