import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pitchcounterapp/api/users.dart';
import 'package:pitchcounterapp/notifier/auth_notifier.dart';
import 'package:pitchcounterapp/screens/game_list.dart';
import 'package:pitchcounterapp/screens/pitchers_list.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    print("Building Feed");

    return new Scaffold(
        appBar: AppBar(
          title: Text(
            authNotifier.user != null ? authNotifier.user.displayName: "Home",
            style: TextStyle(fontSize: 25, fontFamily: 'Bangers'),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => signout(authNotifier),
              child: Text(
                "Logout",
                style: TextStyle(fontSize: 25, color: Colors.white,fontFamily: 'Bangers'),
              ),
            ),
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/baseball3.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child:ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0,50,0,0),
                    child: Text(
                      'Baseball Pitch',
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          fontFamily: "Frijole"
                      ),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0,0,0,50),
                    child: Text(
                      'Counter',
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          fontFamily: "Frijole"
                      ),
                    )),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(120,0,120,0),
                    child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Game Lisst',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Bangers'
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context){
                                return GameList();
                              }));
                        }
                    )
                ),
                Container(
                    height: 100,
                    padding: EdgeInsets.fromLTRB(120,50,120,0),
                    child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Pitchers List',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Bangers'
                          ),),
                        onPressed: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context){
                                return PitchersList();
                              }));
                        }
                    )),
              ],
            )));
  }

}