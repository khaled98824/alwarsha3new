import 'dart:async';
import 'package:alwarsha3/ui/enterName.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:alwarsha3/models/StaticVirables.dart';
import 'PageRoute.dart';
import 'allMadfoaatForOne.dart';
import 'madfoaat.dart';

class ShowAllMadfoaat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MadfoaatF();
  }
}

class MadfoaatF extends StatefulWidget {
  @override
  _MadfoaatFState createState() => _MadfoaatFState();
}

String tabelName;
String serchNameMadfoaat;
double sumMadfoaat = 0.0;
String serchName;
bool showListMadfoaat = false;
QuerySnapshot qus ;
class _MadfoaatFState extends State<MadfoaatF> {


  DateTime time;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocumentValue();
  }

  Future getDocumentValue() async {
    DocumentReference documentRef = Firestore.instance.collection(
        'Madfoaat:$tabelNameSet').document();
    usersList = await documentRef.get();

    var firestore = Firestore.instance;
    qus = await firestore.collection('Madfoaat:$tabelNameSet').getDocuments();
    setState(() {
      showListMadfoaat = true;
    });
    print(nameZoneSet);
    print(tabelNameSet);
    sumMadfoaatF();
    return qus.documents;
  }

  double sumYomiat = 0.0;

  sumMadfoaatF() {
    sumMadfoaat = 0.0;
    Timer(Duration(microseconds:20),(){
      for(int i =0 ; i < qus.documents.length ; i++){
        setState(() {
          sumMadfoaat = sumMadfoaat.toDouble() +  qus.documents[i]['amount'] ;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    Virables.table = tabelName;
    Virables.nameSearchMadfoaat = serchNameMadfoaat;
    return showListMadfoaat? SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              centerTitle: true,
              title: Text(
                'سجل كل الدفعات',
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
                    Navigator.pushReplacement(context, BouncyPageRoute(widget: Madfoaat()));
                    // Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios, color: Colors.white, size: 26,)),
            ),
            body: Container(
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
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Container(
                      child: Center(
                        child: Text(' مجموع قيمة المدفوعات : ${sumMadfoaat.toString()}',style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontFamily: 'AmiriQuran',
                            height: 1
                        ),),
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(top: 14)),
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
                                height: 65,
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                      qus.documents[position]['name'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'AmiriQuran',
                                          height: 1.5
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${qus.documents[position]['time']}الوقت ',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.green[900]),
                                    ),
                                    leading: InkWell(
                                      onLongPress: (){
                                        setState(() {
                                          Firestore.instance.collection(
                                              'Madfoaat:$tabelNameSet')
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
                                            ShowMessage3();
                                          }),
                                    ),
                                    trailing: Text('${ qus.documents[position]['amount'].toString()}',style: TextStyle(
                                      fontSize: 18
                                    ),),
                                    onTap: () {
                                        serchNameMadfoaat = qus.documents[position]['name'];
                                      Navigator.pushReplacement(context,
                                          BouncyPageRoute(widget: allMadfoaatForOne()));

                                    },
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ))
        )
    ):Container();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    sumMadfoaat = 0.0;
  }
  ShowMessage3() {
    Fluttertoast.showToast(
        msg: 'اظغط بإستمرار للحذف ',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 28,
        textColor: Colors.white);
  }

}
