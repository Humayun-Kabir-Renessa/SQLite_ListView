import 'package:flutter/cupertino.dart';
// This is Fruit model class.
class Fruit{
  int id;
  final String name;
  final String taste;
  final String season;

  Fruit({
    required this.id,
    required this.name,
    required this.taste,
    required this.season
});

  // convert Fruit to map
Map<String, dynamic> toMap(){
  return{
    'name': this.name,
    'taste': this.taste,
    'season': this.season
  };
}
// String
@override
  String toString(){
  return 'Fruit{id: $id, name: $name, taste: $taste, season: $season}';
}
}