import 'dart:async';
import 'dart:io';
import 'package:alwarsha3/models/massrofatModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:alwarsha3/models/StaticVirables.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'PageRoute.dart';
import 'allMassrofat.dart';
import 'enterName.dart';


class Massrofat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MassrofatF();
  }
}

class MassrofatF extends StatefulWidget {
  @override
  _MassrofatFState createState() => _MassrofatFState();
}

TextEditingController amountTextController = TextEditingController();

String tabelName;
String serchName;
double amount;
String amountText;
TextEditingController nameTextController = TextEditingController();

class _MassrofatFState extends State<MassrofatF> {

  String time = DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()).toString();


  String info = '';
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
                'المصروفات اليومية ',
                style: TextStyle(
                    fontSize: 28, fontFamily: 'AmiriQuran', height: 1),
              ),
            ),
            body: ListView(
                children: <Widget>[ Container(
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
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 40)),
                      Container(
                        width: 310,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Center(
                          child: Text('لتسجيل المصاريف ضع القيمة في الحقل ثم اظغط على زر سجل ',
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
                      Padding(padding: EdgeInsets.only(top:11)),
                      Container(
                        height: 4,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.deepOrange
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top:11)),
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
                          padding: EdgeInsets.only(top: 50),
                          width: 350,
                          height: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
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
                                    height: 50,
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
                                                BorderRadius.circular(10)),
                                            hintText: '!...أدخل قيمة المصروفات هنا',
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
                                    width: 88,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.deepOrange),
                                    child: Center(
                                      child: Text('قيمة المصروف',style:
                                      TextStyle(
                                          color: Colors.white,
                                          fontSize: 16
                                      ),),
                                    ),
                                  )
                                ],
                              ),
                              RaisedButton(
                                  child: Text(
                                    'سجل',
                                    style: TextStyle(
                                        color: Colors.white,

                                        fontSize: 18,
                                        height: 1),
                                  ),
                                  color: Colors.blue[600],
                                  onPressed: () {
                                    if (amountText !=null && amountText !=''){
                                      amount = double.parse(amountText);

                                      addYom(MassrofatModel(
                                          '',
                                          tabelName,
                                          DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()).toString(),
                                          amount,
                                          'normal'));
                                    }else{
                                      showMessage2();
                                    }

                                  }
                                  ),
                            ],
                          )),
                      Padding(padding: EdgeInsets.only(top: 30)),
                      InkWell(
                        onTap:() {
                          Navigator.push(context,
                              BouncyPageRoute(widget: ShowAllMassrofat()));
                        } ,
                        child: Container(
                          width: 222,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue
                          ),
                          child: Center(
                            child:Text('إذهب الى كل المصروفات',textAlign: TextAlign.center,
                              style:
                              TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontFamily: 'AmiriQuran',
                                  height: 1
                              ),
                            ) ,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Container(
                        height: 5,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 54),
                          child: SpinKitFoldingCube(
                            color: Colors.lightBlue,
                            size: 77,
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
  showMessage2(){
    Fluttertoast.showToast(msg: 'قم بإدخال المصروف أولاً',
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 28,
        textColor: Colors.white
    );
  }
  showMessage3(){
    Fluttertoast.showToast(msg: 'تم تسجيل المصروف',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 28,
        textColor: Colors.white
    );
  }

  var massrofReference = FirebaseDatabase.instance.reference();

  DatabaseReference getMassrofReference() {
    massrofReference = massrofReference.root();
    return massrofReference;
  }

  void addYom(MassrofatModel massrofModel) {
    Firestore.instance.collection('Massrofat:$tabelNameSet').document().setData({
        'UserName': tabelNameSet,
        'time': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
        'zoneName':nameZoneSet,
        'amount':amountTextController.text });
    Timer(Duration(milliseconds: 300),(){
      amountTextController.clear();
      showMessage3();
    });
  }







}
