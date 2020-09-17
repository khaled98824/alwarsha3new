import 'package:firebase_database/firebase_database.dart';

class MassrofatModel {
  String _id ;
  String _name ;
  String _time ;
  dynamic _amount ;
  String _description = 'a';

  MassrofatModel(
      this._id, this._name, this._time, this._amount, this._description);

  MassrofatModel.map(dynamic obj){
    this._id = obj['id'];
    this._name = obj['name'];
    this._time = obj['time'];
    this._amount = obj['amount'];
    this._description = obj['description'];
  }

  String get id => _id;
  String get name => _name;
  String get time => _time;
  dynamic get statues => _amount;
  String get description => _description;

  MassrofatModel.FromSnapShot(DataSnapshot snapshot){
    _id = snapshot.key;
    _name = snapshot.value['name'];
    _time = snapshot.value['time'];
    _amount = snapshot.value['amount'];
    _description = snapshot.value['description'];
  }

  toSnapShot(){
    var value = {
      'name' : _name,
      'time': _time,
      'amount': _amount,
      'description': _description
    };
    return value;
  }

}