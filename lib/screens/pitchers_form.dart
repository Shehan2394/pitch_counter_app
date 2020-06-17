import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pitchcounterapp/api/users.dart';
import 'package:pitchcounterapp/model/pitchers.dart';
import 'package:pitchcounterapp/notifier/pitchers_notifier.dart';
import 'package:provider/provider.dart';

class PitchersForm extends StatefulWidget {

  final bool isUpdating;
  PitchersForm({@required this.isUpdating});

  @override
  _PitchersFormState createState() => _PitchersFormState();
}

class _PitchersFormState extends State<PitchersForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Pitchers _currentPitchers;
  String _imageUrl;
  File _imageFile;

  @override
  void initState() {
    super.initState();
    PitchersNotifier pitchersNotifier = Provider.of<PitchersNotifier>(context, listen: false);

    if (pitchersNotifier.currentPitchers != null) {
      _currentPitchers = pitchersNotifier.currentPitchers;
    } else{
      _currentPitchers = Pitchers();
    }
    _imageUrl = _currentPitchers.image;
  }

  Widget _showImage() {
    if (_imageFile == null && _imageUrl == null){
      return Text("Image Here",style: TextStyle(fontSize: 15,fontFamily: 'Roboto-Regular',color: Colors.white,));
    }else if(_imageFile != null) {
      print('showing image from local file');
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(10),
            color: Colors.black54,
            child: Text('Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'Bangers',
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }else if(_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            fit: BoxFit.cover,
            height: 200,
          ),
          FlatButton(
            padding: EdgeInsets.all(10),
            color: Colors.black54,
            child: Text('Change Image',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Bangers',
                fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  _getLocalImage() async{
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
        imageQuality: 50,
      maxWidth: 400
    );

    if(imageFile != null){
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name',
          labelStyle: TextStyle(fontSize: 20, fontFamily: 'Roboto-Regular',color: Colors.white)),
      initialValue: _currentPitchers.name,
      keyboardType: TextInputType.text,
      style: TextStyle(
        fontSize: 20,
        fontFamily: 'Roboto-Regular',
        color: Colors.white,
      ),
      validator: (String value){
        if(value.isEmpty){
          return 'Name is required';
        }
        if(value.length <3 || value.length >20){
          return 'Name must be more than 3 and less than 20';
        }
        return null;
      },
      onSaved: (String value){
        _currentPitchers.name = value;
      },
    );
  }

  Widget _buildNumberField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Number',
          labelStyle: TextStyle(fontSize: 20, fontFamily: 'Roboto-Regular',color: Colors.white)),
      initialValue: _currentPitchers.number,
      keyboardType: TextInputType.text,
      style: TextStyle(
          fontSize: 20,
          fontFamily: 'Roboto-Regular',
          color: Colors.white,
      ),
      validator: (String value){
        if(value.isEmpty){
          return 'Number is required';
        }
        if(value.length <1 || value.length >3){
          return 'Number must be more than 1 and less than 99';
        }
        return null;
      },
      onSaved: (String value){
        _currentPitchers.number = value;
      },
    );
  }

  _onPitcherUploaded(Pitchers pitchers) {
    PitchersNotifier pitchersNotifier = Provider.of<PitchersNotifier>(context, listen: false);
    pitchersNotifier.addPitchers(pitchers);
    Navigator.pop(context);
  }

  _savePitcher() {
    print('savePitcher Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    uploadPitchersAndImage(_currentPitchers, widget.isUpdating, _imageFile, _onPitcherUploaded );

    print("name: ${_currentPitchers.name}");
    print("number: ${_currentPitchers.number}");
    print("_imageFile: ${_imageFile.toString()}");
    print("_imageUrl: $_imageUrl");
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
          title: Text('Pitchers Form',
            style: TextStyle(
                fontSize: 25,
                fontFamily: 'Bangers'),
          )),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/baseball5.png"),
            fit: BoxFit.cover,
          ),
        ),
       child:Container(
        padding: EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: Column(children: <Widget>[
              Text(
              widget.isUpdating ? "Edit Pitcher" : "Add Pitcher",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30,
                fontFamily: 'Boogaloo',
                color: Colors.white,),
              ),
              SizedBox(height: 16),
              _showImage(),
              SizedBox(height: 16),
              _imageFile == null && _imageUrl == null
              ? ButtonTheme(
                  child: RaisedButton(
                    onPressed: () => _getLocalImage(),
                    child: Text(
                      'Add Image',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Bangers'),
                    ),
                  ),
                )
              :SizedBox(height: 0),
              _buildNameField(),
              _buildNumberField(),
              SizedBox(height: 16),
              ]),
        ),
       ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _savePitcher(),
        child: Icon(Icons.save),
        foregroundColor: Colors.white
      ),
    );
  }
}