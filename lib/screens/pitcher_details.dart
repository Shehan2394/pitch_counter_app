import 'package:flutter/material.dart';
import 'package:pitchcounterapp/api/users.dart';
import 'package:pitchcounterapp/model/pitchers.dart';
import 'package:pitchcounterapp/notifier/pitchers_notifier.dart';
import 'package:pitchcounterapp/screens/pitchers_form.dart';
import 'package:provider/provider.dart';

class PitcherDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PitchersNotifier pitchersNotifier = Provider.of<PitchersNotifier>(context);

    _onPitchersDeleted(Pitchers pitchers){
      Navigator.pop(context);
      pitchersNotifier.deletePitchers(pitchers);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pitchersNotifier.currentPitchers.name,
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
              Image.network(pitchersNotifier.currentPitchers.image != null ? pitchersNotifier.currentPitchers.image
                  : 'https://www.testingxperts.com/wp-content/themes/testingxperts/images/placeholder-img.jpg',
                width: 215,
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: 16,
              ),
              Text(pitchersNotifier.currentPitchers.number,
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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
          FloatingActionButton(
            heroTag: 'button1',
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context){
                    var pitchersForm = PitchersForm(isUpdating: true,);
                    return pitchersForm;
                  })
              );
            },
            child: Icon(Icons.edit),
            foregroundColor: Colors.white,
          ),
          SizedBox(height: 20,),
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () => deletePitchers(pitchersNotifier.currentPitchers, _onPitchersDeleted),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],)
    );
  }
}