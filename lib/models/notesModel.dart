import 'package:firebase_database/firebase_database.dart';

class NotesModel {
  String _id ;
  String _text ;
  String _time ;
  String _description = 'a';

  NotesModel(
      this._id, this._text, this._time,  this._description);

  NotesModel.map(dynamic obj){
    this._id = obj['id'];
    this._text = obj['text'];
    this._time = obj['time'];
    this._description = obj['description'];
  }

  String get id => _id;
  String get name => _text;
  String get time => _time;
  String get description => _description;

  NotesModel.FromSnapShot(DataSnapshot snapshot){
    _id = snapshot.key;
    _text = snapshot.value['text'];
    _time = snapshot.value['time'];
    _description = snapshot.value['description'];
  }

  toSnapShot(){
    var value = {
      'text' : _text,
      'time': _time,
      'description': _description
    };
    return value;
  }

}