

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:pitchcounterapp/model/game.dart';

class GameNotifier with ChangeNotifier {
  List<Game>_gameList = [];
  Game _currentGame;

  UnmodifiableListView<Game> get gameList => UnmodifiableListView(_gameList);

  Game get currentGame => _currentGame;

  set gameList(List<Game> gameList) {
    _gameList = gameList;
    notifyListeners();
  }

  set currentGame(Game game) {
    _currentGame = game;
    notifyListeners();
  }
}