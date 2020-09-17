import 'dart:async';
import 'dart:io';
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

class _YomiatFState extends State<YomiatF> with WidgetsBindingObserver{
  StreamSubscription<Event> _streamSubscription;

  DateTime time;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 100), () {
      _streamSubscription = yomReference
          .child('yomiat:$tabelNameSet')
          .onChildAdded
          .listen(_onChildAdd);
     // searchList = allList;

    });
    Timer(Duration(milliseconds: 300),(){
      searchYom(nameZoneSet);
    });
    Timer(Duration(seconds: 2),(){
      setState(() {
        sumYomiatF();
      });

    });
  }

  List<YomiatModel> searchList = List();

  List<YomiatModel> allList = List();
  void _onChildAdd(Event event) {
    YomiatModel yomiat = YomiatModel.FromSnapShot(event.snapshot);

    setState(() {
      allList.add(yomiat);
    });
  }
  double sumYomiat =0.0;

  sumYomiatF() {
    sumYomiat = 0;
Timer(Duration(milliseconds: 200),(){
  for (int i = 0; i < allList.length; i++) {
    setState(() {
      sumYomiat = sumYomiat.toDouble() + allList[i].statues/2;
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
                    fontSize: 31, fontFamily: 'AmiriQuran', height: 1),
              ):Text(
                'كل اليوميات ',
                style: TextStyle(
                    fontSize: 31, fontFamily: 'AmiriQuran', height: 1),
              ),
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
                            'لعرض كل يوميات عامل معين ورؤية مجموعها فقط إظغط على إسمه',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
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
                      child: Container(
                        child: ListView.builder(
                            itemCount: searchList.length,
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
                                      searchList[position].name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'AmiriQuran',
                                          height: 1.5),
                                    ),
                                    subtitle: Text(
                                      searchList[position].time,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green[900]),
                                    ),
                                    leading: InkWell(
                                      onLongPress: (){
                                        deleteYom(searchList[position].id);
                                        searchList.removeAt(position);
                                        setState(() {
                                          searchList = searchList;
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
                                      searchList[position].statues == 1
                                          ? "نصف يوم"
                                          : 'يوم',
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    onTap: () {
                                      serchName = searchList[position].name;
                                      print(searchList.length);
//                                      Navigator.push(
//                                          context,
//                                          BouncyPageRoute(
//                                              widget: allYomiatForOne(),
//                                          ),
//                                      );

                                    },
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ))));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamSubscription.cancel();

  }



  ShowMessage2() {
    Fluttertoast.showToast(
        msg: 'اظغط بإستمرار لحذف اليوميهً ',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 28,
        textColor: Colors.white);
  }

  var yomReference = FirebaseDatabase.instance.reference();

  DatabaseReference getYomReference() {
    yomReference = yomReference.root();
    return yomReference;
  }

  void deleteYom(String id) {
    yomReference = getYomReference();
    yomReference.child('yomiat:$tabelNameSet').child(id).remove();
    sumYomiatF();
  }
  void searchYom(String searchStatment) {
    searchList.clear();
    setState(() {
      allList = searchList;
    });
    Query query = yomReference
        .child('yomiat:$tabelNameSet')
        .orderByChild('description')
        .equalTo(nameZoneSet.trim());

    query.once().then((snapshot) {
      String name, time, description;
      int statues;
      snapshot.value.forEach((key, value) {
        name = value['name'].toString().trim();
        time = value['time'].toString().trim();
        statues = value['statues'];
        description = value['description'].toString().trim();
        allList.add(YomiatModel(key, name, time, statues, description));
      });
    });
  }
}
