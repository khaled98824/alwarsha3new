import 'dart:async';
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
          while (allList.length > i) {
            deleteAllYom(allList[i].id);
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
    _streamSubscription =
        yomReference.child('yomiat:$tabelNameSet').onChildAdded.listen(_onChildAdd);

    Timer(Duration(milliseconds: 400), () {
      searchYom(serchName);
      sumYomiatF();
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

  sumYomiatF() {
    sumYomiat = 0;
    Timer(Duration(milliseconds: 100), () {
      for (int i = 0; i < searchList.length; i++) {
        setState(() {
          sumYomiat = sumYomiat.toDouble() + searchList[i].statues;
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
                        fontSize: 32, fontFamily: 'AmiriQuran', height: 1),
                  ),
                  Text(
                    ' مجموع يوميات ',
                    style: TextStyle(
                        fontSize: 32, fontFamily: 'AmiriQuran', height: 1),
                  ),
                ],
              ),
              actions: <Widget>[],
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
                      child: Container(
                        child: ListView.builder(
                            itemCount: allList.length,
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
                                      allList[position].name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'AmiriQuran',
                                          height: 1.5),
                                    ),
                                    subtitle: Text(
                                      '${allList[position].time}الوقت ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.green[900]),
                                    ),
                                    leading: InkWell(
                                      onLongPress: (){
                                        deleteYom(allList[position].id);
                                        allList.removeAt(position);
                                        setState(() {
                                          allList = allList;
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
                                    trailing: Text(
                                      allList[position].statues == 1
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
    sumYomiat = 0.0;
  }

  ShowMessage() {
    Fluttertoast.showToast(
        msg: 'تم حذف كامل المعلومات',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.grey,
        fontSize: 28,
        textColor: Colors.white);
  }

  ShowMessage2() {
    Fluttertoast.showToast(
        msg: 'اظغط بإستمرار لحذف السجل كاملاً ',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 28,
        textColor: Colors.white);
  }

  ShowMessage3() {
    Fluttertoast.showToast(
        msg: 'اظغط بإستمرار لحذف اليوميه ',
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

  void deleteAllYom(String id) {
    yomReference = getYomReference();
    yomReference.child('yomiat:$tabelNameSet').child(id).remove();
    ShowMessage();
  }

  void searchYom(String searchStatment) {
    searchList.clear();
    setState(() {
      allList = searchList;
    });
    Query query = yomReference
        .child('yomiat:$tabelNameSet')
        .orderByChild('name')
        .equalTo(searchStatment.trim());

    query.once().then((snapshot) {
      String name, time, description;
      int statues;
      snapshot.value.forEach((key, value) {
        name = value['name'].toString().trim();
        time = value['time'].toString().trim();
        statues = value['statues'];
        description = value['description'].toString().trim();
        searchList.add(YomiatModel(key, name, time, statues, description));
      });
    });
  }
}
