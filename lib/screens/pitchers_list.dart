import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pitchcounterapp/api/users.dart';
import 'package:pitchcounterapp/notifier/pitchers_notifier.dart';
import 'package:pitchcounterapp/screens/pitcher_details.dart';
import 'package:pitchcounterapp/screens/pitchers_form.dart';
import 'package:provider/provider.dart';

class PitchersList extends StatefulWidget {
  @override
  _PitchersListState createState() => _PitchersListState();
}

class _PitchersListState extends State<PitchersList> {
  @override
  void initState() {
    PitchersNotifier pitchersNotifier = Provider.of<PitchersNotifier>(context,listen: false);
    getPitchers(pitchersNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PitchersNotifier pitchersNotifier = Provider.of<PitchersNotifier>(context);

    return new Scaffold(
        appBar: AppBar(
          title: Text(
            "Pitchers List",
            style: TextStyle(fontSize: 25, fontFamily: 'Bangers'),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/baseball4.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child:ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image.network(
                    pitchersNotifier.pitchersList[index].image != null ? pitchersNotifier.pitchersList[index].image
                        : 'https://www.testingxperts.com/wp-content/themes/testingxperts/images/placeholder-img.jpg' ,
                    width: 60,
                    fit: BoxFit.fill,
                  ),
                  title: Text(pitchersNotifier.pitchersList[index].name,
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Boogaloo',
                      color: Colors.white,
                    ),),
                  subtitle: Text(pitchersNotifier.pitchersList[index].number,
                    style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Boogaloo',
                    color: Colors.white,
                    ),),
                  onTap: (){
                    pitchersNotifier.currentPitchers = pitchersNotifier.pitchersList[index];
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context){
                        return PitcherDetails();
                    }));
                  },
                );
              },
              itemCount: pitchersNotifier.pitchersList.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: Colors.black54,
                );
              },
            ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            pitchersNotifier.currentPitchers = null;
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context){
                  return PitchersForm(isUpdating: false,);
                })
            );
          },
          child: Icon(Icons.add),
          foregroundColor: Colors.white,
        )
    );
  }
}