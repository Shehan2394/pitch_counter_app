



import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pitchcounterapp/model/game.dart';
import 'package:pitchcounterapp/model/pitchers.dart';
import 'package:pitchcounterapp/model/user.dart';
import 'package:pitchcounterapp/notifier/auth_notifier.dart';
import 'package:pitchcounterapp/notifier/game_notifier.dart';
import 'package:pitchcounterapp/notifier/pitchers_notifier.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

login(User user, AuthNotifier authNotifier) async{
  AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
    }
  }
}

signup (User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = user.displayName;

    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      await firebaseUser.updateProfile(updateInfo);

      await firebaseUser.reload();

      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      authNotifier.setUser(currentUser);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}

getPitchers(PitchersNotifier pitchersNotifier) async{
  QuerySnapshot snapshot = await Firestore.instance
      .collection('Pitchers')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Pitchers>_pitchersList = [];

  snapshot.documents.forEach((document) {
    Pitchers pitchers = Pitchers.fromMap(document.data);
    _pitchersList.add(pitchers);
  });
  pitchersNotifier.pitchersList = _pitchersList;
}

getGame(GameNotifier gameNotifier) async{
  QuerySnapshot snapshot = await Firestore.instance
      .collection('Game')
      .getDocuments();

  List<Game>_gameList = [];

  snapshot.documents.forEach((document) {
    Game game = Game.fromMap(document.data);
    _gameList.add(game);
  });
  gameNotifier.gameList = _gameList;
}

uploadPitchersAndImage(Pitchers pitchers, bool isUpdating, File localFile,Function pitchersUploaded) async {
  if(localFile != null){
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('Pitchers/Images/$uuid$fileExtension');
    
    await firebaseStorageRef.putFile(localFile).onComplete.catchError(
        (onError){
          print(onError);
          return false;
        }
    );

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");

    _uploadPitcher(pitchers, isUpdating, pitchersUploaded, imageUrl: url);

  }else{
    print("...skipping image upload");

    _uploadPitcher(pitchers, isUpdating, pitchersUploaded);

  }
}

_uploadPitcher(Pitchers pitchers, bool isUpdating, Function pitchersUploaded, {String imageUrl}) async {
  CollectionReference pitchersRef = Firestore.instance.collection('Pitchers');

  if(imageUrl != null){
    pitchers.image = imageUrl;
  }

  if(isUpdating){
    pitchers.updatedAt = Timestamp.now();

    await pitchersRef.document(pitchers.id).updateData(pitchers.toMap());

    pitchersUploaded(pitchers);
    print('updated pitchers with id: ${pitchers.id}');
  }else{
    pitchers.createdAt = Timestamp.now();

    DocumentReference documentRef = await pitchersRef.add(pitchers.toMap());

    pitchers.id = documentRef.documentID;

    print('uploaded pitchers successfully: ${pitchers.toString()}');

    await documentRef.setData(pitchers.toMap(), merge: true);

    pitchersUploaded(pitchers);
  }
}

deletePitchers(Pitchers pitchers, Function pitchersDeleted) async {
  if (pitchers.image != null) {
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(pitchers.image);
    
    print(storageReference.path);
    
    await storageReference.delete();
    
    print('image deleted');
  }
  
  await Firestore.instance.collection('Pitchers').document((pitchers.id)).delete();
  pitchersDeleted(pitchers);
}