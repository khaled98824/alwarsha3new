import 'dart:async';
import 'dart:io';
import 'package:alwarsha3/models/massrofatModel.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
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

    Timer(Duration(milliseconds: 100), () {
      _streamSubscription = massrofReference
          .child('massrofat:$tabelNameSet')
          .onChildAdded
          .listen(_onChildAdd);
    });
    Timer(Duration(milliseconds: 300),(){
      searchYom(nameZoneSet);
    });
    Timer(Duration(milliseconds: 500),(){
      sumMassrofatF();
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

  sumMassrofatF(){
    sumMassrofat = 0;
    Timer(Duration(milliseconds: 400),(){
      for(int i =0 ; i < searchMassrofat.length ; i++){
        setState(() {
          sumMassrofat = sumMassrofat.toDouble() +  searchMassrofat[i].statues ;
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
                    fontSize: 32, fontFamily: 'AmiriQuran', height: 1),
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
                            itemCount: searchList.length,
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
                                          "${searchList[position].statues.toString()} : المبلغ ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: 'AmiriQuran',
                                              height: 1.5
                                          ),
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${searchList[position].time}الوقت ',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.green[900]),
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
                                    trailing: Icon(Icons.monetization_on),
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
  List<MassrofatModel> searchMassrofat = List();
  void searchYom (String searchStatment){
    searchMassrofat.clear();
    setState(() {
      searchMassrofat = allList;
    });
    Query query = massrofReference
        .child('massrofat:$tabelNameSet').orderByChild('description').
    equalTo(nameZoneSet.trim());

    query.once().then((snapshot){
      String name,time,description;
      double amount ;
      snapshot.value.forEach((key ,value){
        name = value['name'].toString().trim();
        time = value['time'].toString().trim();
        amount = value['amount'];
        description = value['description'].toString().trim();
        searchList.add(MassrofatModel(key, name, time, amount, description));

      });
    });
    print(searchMassrofat.length);
  }

}
