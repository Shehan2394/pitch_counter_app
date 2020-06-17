
import 'package:cloud_firestore/cloud_firestore.dart';

class Pitchers {
  String id;
  String name;
  String number;
  String image;
  List subIngredients = [];
  Timestamp createdAt;
  Timestamp updatedAt;

  Pitchers();

  Pitchers.fromMap(Map<String, dynamic> data){
    id = data['id'];
    name = data['name'];
    number = data['number'];
    image = data['image'];
    subIngredients = data['subIngredients'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }
  
  Map<String, dynamic> toMap() {
  return{
    'id': id,
    'name': name,
    'number': number,
    'image': image,
    'subIngredients': subIngredients,
    'cretedAt': createdAt,
    'updatedAt': updatedAt,
  };
 }
}

