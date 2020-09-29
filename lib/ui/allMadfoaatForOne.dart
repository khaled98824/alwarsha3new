import 'dart:async';
import 'dart:io';
import 'package:alwarsha3/models/massrofatModel.dart';
import 'package:alwarsha3/ui/enterName.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:alwarsha3/models/StaticVirables.dart';
import 'PageRoute.dart';
import 'allMadfoaat.dart';
import 'allYomiat.dart';

class allMadfoaatForOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return allMadfoaatForOneF();
  }
}

class allMadfoaatForOneF extends StatefulWidget {
  @override
  _allMadfoaatForOneState createState() => _allMadfoaatForOneState();
}
double sumMadfoaat = 0.0;
bool showListMadfoaat=false;
QuerySnapshot qusMadfoaat ;
class _allMadfoaatForOneState extends State<allMadfoaatForOneF> {
  DateTime time;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  
  _showSnackBarDelete() {
    final snackBar = SnackBar(
      content: Text('اظغط على "تأكيد" لأتمام الحذف'),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,
      elevation: 7,
      action: SnackBarAction(
        label: 'تأكيد',
        textColor: Colors.white,
        disabledTextColor: Colors.blue,
        onPressed: () {
          int i = 0;
          while (qusMadfoaat.documents.length > i) {
            deleteAllYom(qusMadfoaat.documents[i].documentID);
            i++;
          }
          qusMadfoaat.documents.clear();
          sumMadfoaatF();
          setState(() {
            qusMadfoaat = qusMadfoaat;
          });
          ShowMessage();
        },
      ),
    );
    _globalKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(serchNameMadfoaat);
    getDocumentValue();
   
  }
  Future getDocumentValue() async {
    DocumentReference documentRef = Firestore.instance.collection(
        'Madfoaat:$tabelNameSet').document();
    usersList = await documentRef.get();

    var firestore = Firestore.instance;
    qusMadfoaat = await firestore.collection('Madfoaat:$tabelNameSet').where('name',isEqualTo: serchNameMadfoaat).getDocuments();
    setState(() {
      showListMadfoaat = true;
    });
    print(nameZoneSet);
    print(tabelNameSet);
    sumMadfoaatF();
    return qusMadfoaat.documents;
  }

  sumMadfoaatF() {
    sumMadfoaat = 0;
    Timer(Duration(milliseconds: 100), () {
      for (int i = 0; i < qusMadfoaat.documents.length; i++) {
        setState(() {
          sumMadfoaat = sumMadfoaat.toDouble() + qusMadfoaat.documents[i]['amount'];
        });
      }
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _globalKey,
            appBar: AppBar(
                backgroundColor: Colors.blueAccent,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$serchNameMadfoaat',
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.black),
                    ),
                    Text(
                      '  كل الدفعات ل',
                      style: TextStyle(
                          fontSize: 22, fontFamily: 'AmiriQuran', height: 1),
                    ),
                  ],
                ),
              leading: InkWell(
                  onTap: () {
                    setState(() {
                      if (qusMadfoaat != null) {
                        qusMadfoaat.documents.clear();
                      }
                    });
                    Navigator.pushReplacement(context, BouncyPageRoute(widget: ShowAllMadfoaat()));
                    // Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios, color: Colors.white, size: 26,)),
            ),
            body:showListMadfoaat? Container(
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
                    Padding(padding: EdgeInsets.only(top: 6)),
                    Container(
                      child: Center(
                        child: Text(
                          ' مجموع قيمة المدفوعات : ${sumMadfoaat.toStringAsFixed(3)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'AmiriQuran'),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: InkWell(
                              child: Container(
                                width: 158,
                                height: 32,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                  child: Text(
                                    'لحذف الكل اظغط مطولاً',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'AmiriQuran',
                                        height: 1,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              onTap: () {
                                ShowMessage2();
                              },
                              onLongPress: () {
                                _showSnackBarDelete();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: qusMadfoaat.documents.length,
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
                                        qusMadfoaat.documents[position]['name'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontFamily: 'AmiriQuran',
                                            height: 1.5),
                                      ),
                                      subtitle: Text(
                                        '${qusMadfoaat.documents[position]['time']}الوقت ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.green[900]),
                                      ),
                                      leading: InkWell(
                                        onLongPress: () {
                                         deleteYom(position);
                                        },
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              ShowMessage3();
                                            }),
                                      ),
                                      trailing:  Text(
                                              '${qusMadfoaat.documents[position]['amount']}',textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18
                                      ),),
                                    ),
                                  ));
                            }),
                      ),
                    ),
                  ],
                )):Container(),
        ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    sumMadfoaat = 0.0;
  }

  ShowMessage() {
    Fluttertoast.showToast(
        msg: 'تم حذف كامل المعلومات',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.grey,
        fontSize: 22,
        textColor: Colors.white);
  }

  ShowMessage2() {
    Fluttertoast.showToast(
        msg: 'اظغط بإستمرار لحذف السجل كاملاً ',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 22,
        textColor: Colors.white);
  }

  ShowMessage3() {
    Fluttertoast.showToast(
        msg: 'اظغط بإستمرار للحذف ',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 22,
        textColor: Colors.white);
  }

  var massrofReference = FirebaseDatabase.instance.reference();

  DatabaseReference getYomReference() {
    massrofReference = massrofReference.root();
    return massrofReference;
  }

  void addYom(MassrofatModel massrofatModel) {
    massrofReference = getYomReference();
    massrofReference
        .child('madfoaat:$tabelNameSet')
        .push()
        .set(massrofatModel.toSnapShot());
  }

  void updateYom(MassrofatModel massrofatModel) {
    massrofReference = getYomReference();
    massrofReference
        .child('madfoaat:$tabelNameSet')
        .child(massrofatModel.id)
        .update({
      'name': massrofatModel.name,
      'time': massrofatModel.time,
      'amount': massrofatModel.statues,
      'description': massrofatModel.description
    });
  }

  void deleteYom(int position) {
    setState(() {
      Firestore.instance.collection(
          'Madfoaat:$tabelNameSet')
          .document(
          qusMadfoaat.documents[position]
              .documentID)
          .delete().catchError((e) {
        print(e);
      });
      qusMadfoaat = qusMadfoaat;
      getDocumentValue();
    });
    sumMadfoaatF();
  }

  void deleteAllYom(String id) {

    sumMadfoaatF();
  }
}
