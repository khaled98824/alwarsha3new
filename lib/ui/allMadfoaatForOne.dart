import 'dart:async';
import 'dart:io';
import 'package:alwarsha3/models/massrofatModel.dart';
import 'package:alwarsha3/ui/enterName.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:alwarsha3/models/StaticVirables.dart';
import 'allMadfoaat.dart';

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

String tabelName;
double sumMassrofat = 0.0;

class _allMadfoaatForOneState extends State<allMadfoaatForOneF> {
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
          sumMadfoaatF();
          setState(() {
            allList = allList;
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
    _streamSubscription = massrofReference
        .child('madfoaat:$tabelNameSet')
        .onChildAdded
        .listen(_onChildAdd);

    Timer(Duration(milliseconds: 400), () {
      searchYom(serchNameMadfoaat);
      sumMadfoaatF();
    });
  }

  List<MassrofatModel> searchList = List();

  List<MassrofatModel> allList = List();
  void _onChildAdd(Event event) {
    MassrofatModel massrofat = MassrofatModel.FromSnapShot(event.snapshot);

    setState(() {
      allList.add(massrofat);
    });
  }

  sumMadfoaatF() {
    sumMassrofat = 0;
    Timer(Duration(milliseconds: 100), () {
      for (int i = 0; i < searchList.length; i++) {
        setState(() {
          sumMassrofat =
              sumMassrofat.toDouble() + searchList[i].statues - 0.010;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Virables.table = tabelName;
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
                          fontSize: 32,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.black),
                    ),
                    Text(
                      '  كل الدفعات ل',
                      style: TextStyle(
                          fontSize: 32, fontFamily: 'AmiriQuran', height: 1),
                    ),
                  ],
                )),
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
                    Padding(padding: EdgeInsets.only(top: 6)),
                    Container(
                      child: Center(
                        child: Text(
                          ' مجموع قيمة المدفوعات : ${sumMassrofat.toStringAsFixed(3)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
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
                          ),
                        ],
                      ),
                    ),
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
                                  height: 69,
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
                                        onLongPress: () {
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
                                      trailing: allList[position].statues ==
                                              2.01
                                          ? Text('2',textAlign:TextAlign.center,
                                          style: TextStyle(
                                        fontSize: 20
                                      ),)
                                          : Text(
                                              '${allList[position].statues - 0.010}',textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20
                                      ),),
                                    ),
                                  ));
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
    sumMassrofat = 0.0;
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
        msg: 'اظغط بإستمرار للحذف ',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 28,
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

  void deleteYom(String id) {
    massrofReference = getYomReference();
    massrofReference.child('madfoaat:$tabelNameSet').child(id).remove();
    sumMadfoaatF();
  }

  void deleteAllYom(String id) {
    massrofReference = getYomReference();
    massrofReference.child('madfoaat:$tabelNameSet').child(id).remove();
    sumMadfoaatF();
  }

  void searchYom(String searchStatment) {
    searchList.clear();
    setState(() {
      allList = searchList;
    });
    Query query = massrofReference
        .child('madfoaat:$tabelNameSet')
        .orderByChild('name')
        .equalTo(searchStatment.trim());

    query.once().then((snapshot) {
      String name, time, description;
      double amount;
      snapshot.value.forEach((key, value) {
        name = value['name'].toString().trim();
        time = value['time'].toString().trim();
        amount = value['amount'];
        description = value['description'].toString().trim();
        searchList.add(MassrofatModel(key, name, time, amount, description));
      });
    });
  }
}
