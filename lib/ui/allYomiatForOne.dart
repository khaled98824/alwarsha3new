import 'dart:async';
import 'package:alwarsha3/ui/PageRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'allYomiat.dart';
import 'package:alwarsha3/models/StaticVirables.dart';
import 'package:alwarsha3/models/yomiatModel.dart';

import 'enterName.dart';

class allYomiatForOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return allYomiatForOneF();
  }
}
bool showListYomiat = false;
QuerySnapshot qus ;

class allYomiatForOneF extends StatefulWidget {
  @override
  _allYomiatForOneState createState() => _allYomiatForOneState();
}
double sumYomiat = 0.0;

class _allYomiatForOneState extends State<allYomiatForOneF> {
  TextEditingController nameTextController = TextEditingController();
  StreamSubscription<Event> _streamSubscription;
  TextEditingController searchTextController = TextEditingController();

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
          while (qus.documents.length > i) {
            deleteAllYom(qus.documents[i].documentID);
            i++;
          }
          allList.clear();
          sumYomiatF();
          setState(() {
            allList = allList;
          });
        },
      ),
    );
    _globalKey.currentState.showSnackBar(snackBar);
  }

  String info = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(serchName);
    getDocumentValue();
    
  }
  List<YomiatModel> searchList = List();

  Future getDocumentValue() async {
    DocumentReference documentRef = Firestore.instance.collection(
        'Yomiat:$tabelNameSet').document();
    usersList = await documentRef.get();

    var firestore = Firestore.instance;
    qus = await firestore.collection('Yomiat:$tabelNameSet').where(
        'zoneName', isEqualTo: nameZoneSet).where('name',isEqualTo: serchName).getDocuments();
    setState(() {
      showListYomiat = true;
    });
    print(nameZoneSet);
    print(tabelNameSet);
    sumYomiatF();
    return qus.documents;
  }

  List<YomiatModel> allList = List();


  sumYomiatF() {
    sumYomiat = 0;
    Timer(Duration(milliseconds: 100), () {
      for (int i = 0; i < qus.documents.length; i++) {
        setState(() {
          sumYomiat = sumYomiat.toDouble() + qus.documents[i]['status'];
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$serchName',
                    style: TextStyle(
                        fontSize: 26, fontFamily: 'AmiriQuran', height: 1),
                  ),
                  Text(
                    ' مجموع يوميات ',
                    style: TextStyle(
                        fontSize: 26, fontFamily: 'AmiriQuran', height: 1),
                  ),
                ],
              ),
              leading: InkWell(
                  onTap: () {
                    setState(() {
                      if (qus != null) {
                        qus.documents.clear();
                      }
                    });
                    Navigator.pushReplacement(context, BouncyPageRoute(widget: allYomiat()));
                   // Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios, color: Colors.white, size: 26,)),
            ),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Color(0xFF1b1e44),),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                      child: Center(
                        child: Text(
                          ' مجموع اليوميات  : ${sumYomiat / 2}',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: InkWell(
                              child: Container(
                                width: 164,
                                height: 32,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                  child: Text(
                                    'لحذف الكل اظغط مطولاً',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
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
                          )
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Expanded(
                      child:showListYomiat? Container(
                        child: ListView.builder(
                            itemCount: qus.documents.length,
                            itemBuilder: (BuildContext context, position) {
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.red,
                              );
                              return SizedBox(
                                height: 68,
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
                                      '${qus.documents[position]['time']}الوقت ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.green[900]),
                                    ),
                                    leading: InkWell(
                                      onLongPress: (){
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
                                    trailing: Text(
                                        qus.documents[position]['status'] == 1
                                          ? "نصف يوم"
                                          : 'يوم',
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ):Container(),
                    ),
                  ],
                ))));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    sumYomiat = 0.0;
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
        msg: 'اظغط بإستمرار لحذف اليوميه ',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 22,
        textColor: Colors.white);
  }

  void deleteYom(int position) {
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
    sumYomiatF();
  }

  void deleteAllYom(String id) {
    setState(() {
      Firestore.instance.collection(
          'Yomiat:$tabelNameSet')
          .document(id)
          .delete().catchError((e) {
        print(e);
      });
      qus = qus;
      getDocumentValue();
    });
    ShowMessage();
  }

}
