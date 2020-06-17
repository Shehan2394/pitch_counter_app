
import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  String id;
  String name;
  String number;
  String image;
  Timestamp createdAt;

  Game.fromMap(Map<String, dynamic> data){
    id = data['id'];
    name = data['name'];
    number = data['number'];
    image = data['image'];
    createdAt = data['createdAt'];
  }
}