import 'dart:async';
import 'package:alwarsha3/models/notesModel.dart';
import 'package:alwarsha3/ui/enterName.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotesF();
  }
}

class NotesF extends StatefulWidget {
  @override
  _NotesFState createState() => _NotesFState();
}

class _NotesFState extends State<NotesF> {
  StreamSubscription<Event> _streamSubscription;
  TextEditingController txtNotes = TextEditingController();
  String theNote;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 300), () {
      _streamSubscription = noteReference
          .child('Notes:$tabelNameSet')
          .onChildAdded
          .listen(_onChildAdd);
    });
    setState(() {});
  }

  List<NotesModel> allList = List();

  void _onChildAdd(Event event) {
    NotesModel notes = NotesModel.FromSnapShot(event.snapshot);

    setState(() {
      allList.add(notes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('الملاحظات',
              style: TextStyle(
                  color: Colors.white,
                  fontSize:33,
                  fontFamily: 'AmiriQuran',
                  height: 1.5
              ),
            ),
          ),
          body: ListView(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                      Color(0xFF1b1e44),
                      Color(0xFF2d3447),
                    ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        tileMode: TileMode.clamp)),
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      width: 330,
                      height: 46,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Center(
                        child: Text('هنا يمكنك تدوين ملاحاتك ومراجعتها مهما طال الوقت',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontFamily: 'AmiriQuran',
                              height: 1.5
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 6)),
                    Container(
                      width: 390,
                      height: 132,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: txtNotes,
                                maxLines: 3,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    hintText: 'اكتب ملاحظتك هنا'),
                              ),
                              RaisedButton(
                                  color: Colors.blue,
                                  child: Text(
                                    'احفظ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    addYom(NotesModel('', txtNotes.text,
                                        DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()).toString(), 'a'));
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 14)),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: allList.length,
                            itemBuilder: (BuildContext context, position) {
                              Divider(
                                thickness: 4,
                                color: Colors.red,
                              );
                              return SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.all(1),
                                    child: Padding(
                                      padding: EdgeInsets.all(1),
                                      child: Container(
                                        color: Colors.white,
                                        child: ListTile(
                                          enabled: true,
                                          title: Padding(
                                            padding: EdgeInsets.only(top:3,bottom: 6),
                                            child: Text(
                                              allList[position].name,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily: 'AmiriQuran',
                                                height: 1.5
                                                  ),
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${allList[position].time} الوقت',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.green[900]),
                                          ),
                                          leading: InkWell(
                                            onLongPress: (){
                                              deleteNote(allList[position].id);
                                              allList.removeAt(position);
                                              setState(() {
                                                allList = allList;
                                              });

                                            },
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),alignment: Alignment(-5, 4),
                                                onPressed: () {
                                                  ShowMessage2();
                                                }),
                                          ),
                                        ),
                                      ),
                                    ),

                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamSubscription.cancel();
  }

  var noteReference = FirebaseDatabase.instance.reference();

  DatabaseReference getYomReference() {
    noteReference = noteReference.root();
    return noteReference;
  }

  void addYom(NotesModel notesModel) {
    noteReference = getYomReference();
    noteReference.child('Notes:$tabelNameSet').push().set(notesModel.toSnapShot());
  }

  ShowMessage2() {
    Fluttertoast.showToast(
        msg: 'اظغط بإستمرار للحذف',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 28,
        textColor: Colors.white);
  }

  void deleteNote(String id) {
    noteReference = getYomReference();
    noteReference.child('Notes:$tabelNameSet').child(id).remove();
  }
}
