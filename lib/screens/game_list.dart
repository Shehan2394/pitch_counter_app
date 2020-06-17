import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pitchcounterapp/api/users.dart';
import 'package:pitchcounterapp/notifier/game_notifier.dart';
import 'package:pitchcounterapp/screens/game_details.dart';
import 'package:provider/provider.dart';

class GameList extends StatefulWidget {
  @override
  _GameListState createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  @override
  void initState() {
    GameNotifier gameNotifier = Provider.of<GameNotifier>(context,listen: false);
    getGame(gameNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GameNotifier gameNotifier = Provider.of<GameNotifier>(context);

    return new Scaffold(
        appBar: AppBar(
          title: Text(
            "Game List",
            style: TextStyle(fontSize: 25, fontFamily: 'Bangers'),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/baseball2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child:ListView.separated(
            itemBuilder: (BuildContext context, int index,) {
              return ListTile(
                title:Text(gameNotifier.gameList[index].name,
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Boogaloo',
                    color: Colors.white,
                  ),),
                subtitle: Text(gameNotifier.gameList[index].number,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Boogaloo',
                    color: Colors.white,
                  ),),
                onTap: (){
                  gameNotifier.currentGame = gameNotifier.gameList[index];
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context){
                        return GameDetails();
                      }));
                },
              );
            },
            itemCount: gameNotifier.gameList.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(color: Colors.black54,
              );
            },
          ),
        ),
    );
  }
}