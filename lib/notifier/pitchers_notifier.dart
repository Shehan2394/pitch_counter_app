

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:pitchcounterapp/model/pitchers.dart';

class PitchersNotifier with ChangeNotifier {
  List<Pitchers>_pitchersList = [];
  Pitchers _currentPitchers;

  UnmodifiableListView<Pitchers> get pitchersList => UnmodifiableListView(_pitchersList);

  Pitchers get currentPitchers => _currentPitchers;

  set pitchersList(List<Pitchers> pitchersList) {
    _pitchersList = pitchersList;
    notifyListeners();
  }

  set currentPitchers(Pitchers pitchers) {
    _currentPitchers = pitchers;
    notifyListeners();
  }

  addPitchers(Pitchers pitchers) {
    _pitchersList.insert(0, pitchers);
    notifyListeners();
  }

  deletePitchers(Pitchers pitchers) {
    _pitchersList.removeWhere((_pitchers) => _pitchers.id == pitchers.id);
    notifyListeners();
  }
}