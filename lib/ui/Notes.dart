import 'dart:async';
import 'package:alwarsha3/ui/enterName.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

bool showListNotes = false;
QuerySnapshot qus ;

class _NotesFState extends State<NotesF> {
  TextEditingController txtNotes = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocumentValue();
  }
  Future getDocumentValue() async {
    DocumentReference documentRef = Firestore.instance.collection(
        'Notes:$tabelNameSet').document();
    usersList = await documentRef.get();

    var firestore = Firestore.instance;
    qus = await firestore.collection('Notes:$tabelNameSet').getDocuments();
    setState(() {
      showListNotes = true;
    });
    print(nameZoneSet);
    print(tabelNameSet);
    return qus.documents;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('الملاحظات',
              style: TextStyle(
                  color: Colors.white,
                  fontSize:24,
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
                      height: 36,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Center(
                        child: Text('هنا يمكنك تدوين ملاحاتك ومراجعتها مهما طال الوقت',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
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
                                    addNote();
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
                            itemCount: qus.documents.length,
                            itemBuilder: (BuildContext context, position) {
                              Divider(
                                thickness: 4,
                                color: Colors.red,
                              );
                              return showListNotes? SizedBox(
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
                                              qus.documents[position]['Note'],
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
                                            '${qus.documents[position]['time']} الوقت',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.green[900]),
                                          ),
                                          leading: InkWell(
                                            onLongPress: (){
                                              deleteNote(position);
                                            },
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),alignment: Alignment(-5, 4),
                                                onPressed: () {
                                                  showMessage2();
                                                }),
                                          ),
                                        ),
                                      ),
                                    ),

                                ),
                              ):Container();
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
  }

  void addNote() {
    Firestore.instance.collection('Notes:$tabelNameSet').document().setData({
      'UserName': tabelNameSet,
      'time': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
      'zoneName':nameZoneSet,
      'Note':txtNotes.text.toLowerCase().trimLeft()

    });
    Timer(Duration(milliseconds: 300),(){
      txtNotes.clear();
      getDocumentValue();
    });
  }

  showMessage2() {
    Fluttertoast.showToast(
        msg: 'اظغط بإستمرار للحذف',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 18,
        textColor: Colors.white);
  }

  void deleteNote(int position) {
    setState(() {
      Firestore.instance.collection(
          'Notes:$tabelNameSet')
          .document(
          qus.documents[position]
              .documentID)
          .delete().catchError((e) {
        print(e);
      });
      qus = qus;
      getDocumentValue();
    });
  }
}
