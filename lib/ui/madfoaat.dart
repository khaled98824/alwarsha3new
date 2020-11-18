import 'dart:async';
import 'dart:io';
import 'package:alwarsha3/models/StaticVirables.dart';
import 'package:alwarsha3/models/massrofatModel.dart';
import 'package:alwarsha3/ui/enterName.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'PageRoute.dart';
import 'allMadfoaat.dart';
import 'frontBage.dart';


class Madfoaat extends StatelessWidget {
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
String serchName;
double amount;
String amountText;
String nameText;

class _MassrofatFState extends State<MassrofatF> {
  TextEditingController amountTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  var dropItems = ['إلتقاط تاريخ اليوم تلقائياً','تحديد التاريخ يدوياً'];
  var dropSelectItem = 'إلتقاط تاريخ اليوم تلقائياً';
  String time = DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()).toString();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<MassrofatModel> allList = List();
  @override
  Widget build(BuildContext context) {
    Virables.table = tabelName;
    Virables.nameSearchh = serchName;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              centerTitle: true,
              title: Text(
                'المدفوعات',
                style: TextStyle(
                    fontSize: 25, fontFamily: 'AmiriQuran', height: 1),
              ),
            ),
            body: ListView(
                children: <Widget>[ Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Color(0xFF1b1e44),),
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 30)),
                      Container(
                        width: 320,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Center(
                          child: Text('للقيام بتسجيل دفعة قم بإدخال إسم المستلم ثم قيمة الدفعة واظغط على زر سجل',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'AmiriQuran', height: 1.5
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 11)),
                      Container(
                        height: 6,
                        width: 260,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.deepOrange
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 11)),
                      Container(
                        height: 4,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.deepOrange
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 11)),
                      Container(
                        height: 3,
                        width: 140,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.deepOrange
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(top: 11)),

                      Container(
                          padding: EdgeInsets.all(10),
                          width: 350,
                          height: 222,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 200,
                                    height: 48,
                                    child: Card(
                                      elevation: 0,
                                      child: Container(
                                        child: TextFormField(
                                          controller: nameTextController,
                                          textAlign: TextAlign.right,
                                          keyboardType: TextInputType.text,
                                          enableInteractiveSelection: true,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blueAccent),
                                                borderRadius:
                                                BorderRadius.circular(10)),

                                            hintText: '!...أدخل إسم المستلم هنا',
                                            hintStyle: TextStyle(
                                              fontSize: 17,
                                              height: 1
                                            )
                                          ),
                                          cursorRadius: Radius.circular(10),
                                          onChanged: (val){
                                            nameText = val;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.deepOrange),
                                    child: Center(
                                      child: Text('المستلم',style:
                                      TextStyle(
                                          color: Colors.white,
                                          fontSize: 17
                                      ),),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10,),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 200,
                                    height: 48,
                                    child: Card(
                                      elevation: 0,
                                      child: Container(
                                        child: TextFormField(
                                          controller: amountTextController,
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blueAccent),
                                                borderRadius:
                                                BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            hintText: '!...أدخل قيمة الدفعة هنا',
                                            hintStyle: TextStyle(
                                                fontSize: 17,
                                                height: 1
                                            ),
                                            fillColor: Colors.white,
                                            hoverColor: Colors.white,
                                          ),
                                          cursorRadius: Radius.circular(10),
                                          onChanged: (val){
                                            amountText = val;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.deepOrange),
                                    child: Center(
                                      child: Text('قيمة الدفعة',style:
                                      TextStyle(
                                          color: Colors.white,
                                          fontSize: 16
                                      ),),
                                    ),
                                  )
                                ],
                              ),
                             SizedBox(height: 20,),
                              RaisedButton(
                                  child: Text(
                                    'سجل',
                                    style: TextStyle(
                                        color: Colors.white,
                                        // fontFamily: 'AmiriQuran',
                                        fontSize: 18,
                                        height: 1),
                                  ),
                                  color: Colors.blue[600],
                                  onPressed: () {

                                    if (nameText.isNotEmpty && amountTextController.text !='') {
                                      amount = double.parse(amountText);
                                      addMadfoaat();
                                    }else{
                                      ShowMessage2();
                                    }

                                  }),

                            ],
                          )),
                      Padding(padding: EdgeInsets.only(top: 30)),
                      InkWell(
                        onTap:() {
                          Navigator.push(context,
                              BouncyPageRoute(widget: ShowAllMadfoaat()));
                        } ,
                        child: Container(
                          width: 130,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue
                          ),
                          child: Center(
                            child:Text('كل الدفعات',textAlign: TextAlign.center,
                              style:
                              TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontFamily: 'AmiriQuran',
                                  height: 1
                              ),
                            ) ,
                          ),
                        ),
                      ),
                      //SpinKitCubeGrid(size: 51.0, color: Colors.pinkAccent),
                      Padding(
                          padding: EdgeInsets.only(top:heightScreen>750? 64 :34),
                          child: SpinKitFoldingCube(
                            color: Colors.lightBlue,
                            size: 70,
                          )),
                    ],
                  ),
                ),
                ])));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  ShowMessage2(){
    Fluttertoast.showToast(msg: 'إدخل كل المعلومات أولاً',
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 22,
        textColor: Colors.white,

    );
  }
  ShowMessage1(){
    Fluttertoast.showToast(msg: 'تم تسجيل الدفعة',
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.blue,
      fontSize: 22,
      textColor: Colors.white,

    );
  }

  var massrofReference = FirebaseDatabase.instance.reference();

  DatabaseReference getMassrofReference() {
    massrofReference = massrofReference.root();
    return massrofReference;
  }

  void addMadfoaat() {
    Firestore.instance.collection('Madfoaat:$tabelNameSet').document().setData({
      'UserName': tabelNameSet,
      'time': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
      'amount':amount,
      'name': nameTextController.text,
      'zoneName':nameZoneSet,

    });
    Timer(Duration(milliseconds: 300),(){
      nameTextController.clear();
      amountTextController.clear();
      ShowMessage1();
    });

    Firestore.instance.collection('Madfoaat2:$tabelNameSet').document().setData({
      'UserName': tabelNameSet,
      'time': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
      'amount':amount,
      'name': nameTextController.text,
      'zoneName':nameZoneSet,

    });
  }







}
