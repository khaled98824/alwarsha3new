import 'package:firebase_database/firebase_database.dart';

class YomiatModel {
  String _id ;
  String _name ;
  String _time ;
  int _statues ;
  String _description ;

  YomiatModel(
      this._id, this._name, this._time, this._statues, this._description);

  YomiatModel.map(dynamic obj){
    this._id = obj['id'];
    this._name = obj['name'];
    this._time = obj['time'];
    this._statues = obj['statues'];
    this._description = obj['description'];
  }

  String get id => _id;
  String get name => _name;
  String get time => _time;
  int get statues => _statues;
  String get description => _description;

  YomiatModel.FromSnapShot(DataSnapshot snapshot){
    _id = snapshot.key;
    _name = snapshot.value['name'];
    _time = snapshot.value['time'];
    _statues = snapshot.value['statues'];
    _description = snapshot.value['description'];
  }

  toSnapShot(){
    var value = {
      'name' : _name,
      'time': _time,
      'statues': _statues,
      'description': _description
    };
    return value;
  }

}