import 'dart:async';
import 'dart:io';
import 'package:alwarsha3/models/massrofatModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:alwarsha3/models/StaticVirables.dart';
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
  DateTime time;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocumentValue();
    Timer(Duration(milliseconds: 500), (){
      sumMassrofatF();
    });

  }

  Future getDocumentValue() async {
    DocumentReference documentRef = Firestore.instance.collection(
        'Massrofat:$tabelNameSet').document();
    usersList = await documentRef.get();

    var firestore = Firestore.instance;
    qus = await firestore.collection('Massrofat:$tabelNameSet').where('zoneName',isEqualTo: nameZoneSet).getDocuments();
    setState(() {
      showListMassrofat = true;
    });
    print(nameZoneSet);
    print(tabelNameSet);
    sumMassrofatF();
    return qus.documents;
  }

  sumMassrofatF(){
    if(qus!=null){
      sumMassrofat = 0.0;
      for(int i =0 ; i < qus.documents.length ; i++){
        setState(() {
          sumMassrofat = sumMassrofat.toDouble() +  qus.documents[i]['amount'] ;
        });
      }
    }
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
                    fontSize: 22, fontFamily: 'AmiriQuran', height: 1),
              ),
            ),
            body: showListMassrofat?Container(
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
                        child: Text(' مجموع قيمة المصروفات : ${sumMassrofat.toString()}',style: TextStyle(
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
                                        sumMassrofatF();
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
        fontSize: 22,
        textColor: Colors.white
    );
  }
  }

