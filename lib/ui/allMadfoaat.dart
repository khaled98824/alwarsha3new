import 'dart:async';
import 'dart:io';
import 'package:alwarsha3/models/massrofatModel.dart';
import 'package:alwarsha3/ui/enterName.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:alwarsha3/models/StaticVirables.dart';
import 'PageRoute.dart';
import 'allMadfoaatForOne.dart';

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

class _MadfoaatFState extends State<MadfoaatF> {
  TextEditingController nameTextController = TextEditingController();
  StreamSubscription<Event> _streamSubscription;
  TextEditingController searchTextController = TextEditingController();


  DateTime time;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(milliseconds: 200), () {
      _streamSubscription = madfoaatReference
          .child('madfoaat:$tabelNameSet')
          .onChildAdded
          .listen(_onChildAdd);
      Timer(Duration(milliseconds: 400),(){
        sumMassrofatF();
      });
    });

  }
  List<MassrofatModel> searchList = List();
  List<MassrofatModel> allList = List();
  void _onChildAdd(Event event) {
    MassrofatModel madfoaat = MassrofatModel.FromSnapShot(event.snapshot);

    setState(() {
      allList.add(madfoaat);

    });
  }

  sumMassrofatF(){
    sumMadfoaat = 0;
    Timer(Duration(milliseconds: 400),(){
      for(int i =0 ; i < allList.length ; i++){
        setState(() {
          sumMadfoaat = sumMadfoaat.toDouble() +  allList[i].statues - 0.010;
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
                'سجل كل الدفعات',
                style: TextStyle(
                    fontSize: 38, fontFamily: 'AmiriQuran', height: 1),
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
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Container(
                      child: Center(
                        child: Text(' مجموع قيمة المدفوعات : ${sumMadfoaat.toStringAsFixed(3)}',style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'AmiriQuran',
                            height: 1
                        ),),
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(top: 14)),
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
                                          height: 1.5
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${allList[position].time}الوقت ',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.green[900]),
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
                                            print(allList[position].statues);
                                          }),
                                    ),
                                    trailing:allList[position].statues==2.01? Text('2',style: TextStyle(
                                      fontSize: 20
                                    ),): Text('${allList[position].statues-0.010}',style: TextStyle(
                                      fontSize: 20
                                    ),),
                                    onTap: () {
                                      Navigator.push(context,
                                          BouncyPageRoute(widget: allMadfoaatForOne()));
                                      serchNameMadfoaat = allList[position].name;
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

  var madfoaatReference = FirebaseDatabase.instance.reference();

  DatabaseReference getYomReference() {
    madfoaatReference = madfoaatReference.root();
    return madfoaatReference;
  }

  void updateYom(MassrofatModel massrofatModel) {
    madfoaatReference = getYomReference();
    madfoaatReference.child('madfoaat:$tabelNameSet').child(massrofatModel.id).update({
      'name': massrofatModel.name,
      'time': massrofatModel.time,
      'amount': massrofatModel.statues,
      'description': massrofatModel.description
    });
  }

  void deleteYom(String id) {
    madfoaatReference = getYomReference();
    madfoaatReference.child('madfoaat:$tabelNameSet').child(id).remove();
    sumMassrofatF();
  }
  List<MassrofatModel> searchMadfoaat = List();
  void searchYom (String searchStatment){
    searchMadfoaat.clear();
    setState(() {
      allList = searchList;
    });
    Query query = madfoaatReference
        .child('madfoaat:$tabelNameSet').orderByChild('name').
    equalTo(searchStatment.trim());

    query.once().then((snapshot){
      String name,time,description;
      double amount ;
      snapshot.value.forEach((key ,value){
        name = value['name'].toString().trim();
        time = value['time'].toString().trim();
        amount = value['amount'];
        description = value['description'].toString().trim();
        searchMadfoaat.add(MassrofatModel(key, name, time, amount, description));

      });
    });
  }
}
