import 'dart:async';
import 'dart:io';
import 'package:alwarsha3/models/massrofatModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:alwarsha3/models/StaticVirables.dart';
import 'allYomiat.dart';
import 'enterName.dart';

class ShowAllMassrofat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MassrofatF();
  }
}

class MassrofatF extends StatefulWidget {
  @override
  _MassrofatFState createState() => _MassrofatFState();
}

String tabelName;
String serchNameMadfoaat;
double sumMassrofat = 0.0;
bool showListMassrofat = false;
QuerySnapshot qus ;

class _MassrofatFState extends State<MassrofatF> {
  TextEditingController nameTextController = TextEditingController();
  StreamSubscription<Event> _streamSubscription;
  TextEditingController searchTextController = TextEditingController();


  DateTime time;

  String info = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocumentValue();
    Timer(Duration(milliseconds: 300),(){
      //searchYom(nameZoneSet);
    });
    Timer(Duration(milliseconds: 500),(){
     // sumMassrofatF();
    });
  }

  Future getDocumentValue() async {
    DocumentReference documentRef = Firestore.instance.collection(
        'Massrofat:$tabelNameSet').document();
    yomiatList = await documentRef.get();

    var firestore = Firestore.instance;
    qus = await firestore.collection('Massrofat:$tabelNameSet').getDocuments();
    setState(() {
      showListMassrofat = true;
    });
    print(nameZoneSet);
    print(tabelNameSet);
    sumMassrofatF();
    return qus.documents;
  }

  sumMassrofatF(){
    sumMassrofat = 0;
    Timer(Duration(milliseconds: 400),(){
      for(int i =0 ; i < qus.documents.length ; i++){
        setState(() {
          sumMassrofat = sumMassrofat.toDouble() +  qus.documents[i]['statues'] ;
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    Virables.table = tabelName;
    Virables.nameSearchMadfoaat = serchNameMadfoaat;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              centerTitle: true,
              title: Text(
                'سجل كل المصروفات اليومية',
                style: TextStyle(
                    fontSize: 26, fontFamily: 'AmiriQuran', height: 1),
              ),
            ),
            body: showListMassrofat?Container(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                      child: Center(
                        child: Text(' مجموع قيمة المصروفات : ${sumMassrofat.toStringAsFixed(3)}',style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'AmiriQuran',
                            height: 1,
                            color: Colors.white
                        ),),
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(top: 20)),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: qus.documents.length,
                            itemBuilder: (BuildContext context, position) {
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.red,
                              );
                              return SizedBox(
                                height: 70,
                                child: Card(
                                  child: ListTile(
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 2),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 2,horizontal: 3),
                                        child: Text(
                                          "${qus.documents[position]['amount'].toString()} : المبلغ ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: 'AmiriQuran',
                                              height: 1.5
                                          ),
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${qus.documents[position]['time']}الوقت ',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.green[900]),
                                    ),
                                    leading: InkWell(
                                      onLongPress: (){
                                        setState(() {
                                          Firestore.instance.collection(
                                              'Massrofat:$tabelNameSet')
                                              .document(
                                              qus.documents[position]
                                                  .documentID)
                                              .delete().catchError((e) {
                                            print(e);
                                          });
                                          qus = qus;
                                          getDocumentValue();
                                        });
                                      },
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            ShowMessage2();
                                          }),
                                    ),
                                    trailing: Icon(Icons.monetization_on),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                )):Container(),
        )
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    sumMassrofat = 0.0;
  }

  ShowMessage2(){
    Fluttertoast.showToast(msg: 'اظغط بإستمرار للحذف ',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 28,
        textColor: Colors.white
    );
  }

  var massrofReference = FirebaseDatabase.instance.reference();

  DatabaseReference getYomReference() {
    massrofReference = massrofReference.root();
    return massrofReference;
  }

  void deleteYom(String id) {
    massrofReference = getYomReference();
    massrofReference.child('massrofat:$tabelNameSet').child(id).remove();
    sumMassrofatF();
  }
  }

