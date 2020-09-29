import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'PageRoute.dart';
import 'allYomiatForOne.dart';
import 'package:alwarsha3/models/StaticVirables.dart';
import 'package:alwarsha3/models/yomiatModel.dart';

import 'enterName.dart';

class allYomiat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return YomiatF();
  }
}
@override


class YomiatF extends StatefulWidget {
  @override
  _YomiatFState createState() => _YomiatFState();
}

String tabelName;
String serchName;
bool showListYomiat = false;
QuerySnapshot qus ;
class _YomiatFState extends State<YomiatF> with WidgetsBindingObserver {
  DateTime time;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // TODO: implement initState
    super.initState();
    getDocumentValue();
    sumYomiatF();
  }

  Future getDocumentValue() async {
    DocumentReference documentRef = Firestore.instance.collection(
        'Yomiat:$tabelNameSet').document();
    usersList = await documentRef.get();

    var firestore = Firestore.instance;
    qus = await firestore.collection('Yomiat:$tabelNameSet').where(
        'zoneName', isEqualTo: nameZoneSet).getDocuments();
    setState(() {
      showListYomiat = true;
    });
    print(nameZoneSet);
    print(tabelNameSet);
    return qus.documents;
  }

  double sumYomiat = 0.0;

  sumYomiatF() {
    sumYomiat = 0;
    Timer(Duration(milliseconds: 200), () {
      for (int i = 0; i < qus.documents.length; i++) {
        setState(() {
          sumYomiat = sumYomiat.toDouble() + qus.documents[i]['status']/2;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    Virables.table = tabelName;
    Virables.nameSearchh = serchName;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              centerTitle: true,
              title: sumYomiat > 0.0 ? Text(
                'كل اليوميات $sumYomiat',
                style: TextStyle(
                    fontSize: 26, fontFamily: 'AmiriQuran', height: 1),
              ) : Text(
                'كل اليوميات ',
                style: TextStyle(
                    fontSize: 26, fontFamily: 'AmiriQuran', height: 1),
              ),
              leading: InkWell(
                  onTap: () {
                    setState(() {
                      if (qus != null) {
                        qus.documents.clear();
                      }
                    });

                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios, color: Colors.white, size: 26,)),
            ),
            body: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
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
                    Padding(
                        padding: EdgeInsets.only(top: 13),
                        child: SpinKitFoldingCube(
                          color: Colors.lightBlue,
                          size: 33,
                        )),
                    Padding(padding: EdgeInsets.only(top: 11)),
                    Container(
                      width: 300,
                      height: 5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue),
                    ),
                    Padding(padding: EdgeInsets.only(top: 1)),
                    SizedBox(
                      width: 360,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 6, right: 17, left: 17, bottom: 6),
                          child: Text(
                            'لعرض كل يوميات عامل معين ورؤية مجموعها, فقط إظغط على إسمه',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'AmiriQuran',
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Container(
                      width: 410,
                      height: 5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue),
                    ),
                     Expanded(
                      child: StreamBuilder(
                        stream: Firestore.instance.collection(
                            'Yomiat:$tabelNameSet').where(
                            'zoneName', isEqualTo: nameZoneSet).snapshots(),
                        builder: (context, snapshot) {
                          return showListYomiat ? ListView.builder(
                              itemCount: qus.documents.length,
                              itemBuilder: (BuildContext context, position) {
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Colors.red,
                                );
                                return SizedBox(
                                  height: 65,
                                  child: Card(
                                    child: ListTile(
                                      title: Text(
                                        qus.documents[position]['name'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'AmiriQuran',
                                            height: 1.5),
                                      ),
                                      subtitle: Text(
                                        qus.documents[position]['time'],
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.green[900]),
                                      ),
                                      leading: InkWell(
                                        onLongPress: () {
                                          setState(() {
                                            Firestore.instance.collection(
                                                'Yomiat:$tabelNameSet')
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
                                      trailing: Text(
                                        qus.documents[position]['status'] == 1
                                            ? "نصف يوم"
                                            : 'يوم',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      onTap: () {
                                        serchName = qus.documents[position]['name'];
                                        setState(() {
                                          qus.documents.clear();

                                        });
                                     Navigator.pushReplacement(
                                          context,
                                          BouncyPageRoute(
                                            widget: allYomiatForOne(),
                                          ),
                                        );

                                      },
                                    ),
                                  ),
                                );
                              }) : Container();
                        },

                      ),
                    )
                  ],
                ))));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  ShowMessage2() {
    Fluttertoast.showToast(
        msg: 'اظغط بإستمرار لحذف اليوميه',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 22,
        textColor: Colors.white);
  }



}