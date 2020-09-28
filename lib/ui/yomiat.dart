import 'dart:async';
import 'dart:io';
import 'package:alwarsha3/ui/enterName.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:alwarsha3/models/StaticVirables.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'PageRoute.dart';
import 'allYomiat.dart';
import 'frontBage.dart';


class Yomiat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return YomiatF();
  }
}

class YomiatF extends StatefulWidget {
  @override
  _YomiatFState createState() => _YomiatFState();
}
var _formKey = GlobalKey<FormState>();
String serchName;
class _YomiatFState extends State<YomiatF> {
  TextEditingController nameTextController = TextEditingController();
  var dropItems = ['إلتقاط تاريخ اليوم تلقائياً','تحديد التاريخ يدوياً'];
  var dropSelectItem = 'إلتقاط تاريخ اليوم تلقائياً';
  String time = DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()).toString();

  String info = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int dayStatuse = 2;
  bool checkStatuse = true;
  bool checkStatuse2 = false;
  void Check(bool val) {
    setState(() {
      checkStatuse = val;
      dayStatuse = 2;
      if (checkStatuse2 = true) {
        checkStatuse2 = false;
      }
    });
    print(dayStatuse);
  }

  void Check2(bool val) {
    setState(() {
      checkStatuse2 = val;
      dayStatuse = 1;
      if (checkStatuse = true) {
        checkStatuse = false;
      }
    });
    print(dayStatuse);
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
              title: Text(
                'اليوميات',
                style: TextStyle(
                    fontSize: 38, fontFamily: 'AmiriQuran', height: 1),
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(children: <Widget>[
                Container(
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
                        Padding(padding: EdgeInsets.only(top: 55)),
                        Container(
                          width: 340,
                          height: 95,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 6, right: 2, left: 2, bottom: 6),
                            child: Text(
                              'قم بإدخال إسم العامل وإختيار يوم او نصف يوم ثم اظغط على زر سجل لتسجيل اليومية في سجل اليوميات ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'AmiriQuran',
                                height: 1.5,
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
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 340,
                                height: 114,
                                padding:
                                    EdgeInsets.only(left: 10, right: 7, top: 7),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                                child: Column(
                                  children: <Widget>[
                                   Padding(padding: EdgeInsets.only(top: 1),),
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.start,
                                      alignment: WrapAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 230,
                                          height: 50,
                                          child: Card(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 10,
                                                  left: 10,
                                                  bottom: 1,
                                                  top: 1),
                                              child: TextFormField(
                                                // ignore: missing_return
                                                validator: (String value) {
                                                  if (value.isEmpty) {
                                                    return 'Please enter principal amount';
                                                  }
                                                },
                                                maxLines: 2,
                                                controller: nameTextController,
                                                textAlign: TextAlign.right,
                                                decoration: InputDecoration(
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.blueAccent),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                                  alignLabelWithHint: true,
                                                  hintText:
                                                  '!...أدخل إسم العامل هنا',
                                                  fillColor: Colors.white,
                                                  hoverColor: Colors.white,
                                                ),
                                                cursorRadius: Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 74,
                                          height: 55,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 10, bottom:8),
                                            child: Center(
                                              child: RaisedButton(
                                                color: Colors.white,
                                                onPressed: () {
                                                  if (!nameTextController.text.isEmpty) {
                                                    addYom(dayStatuse,);
                                                  }else{
                                                    ShowMessage2();
                                                  }
                                                },
                                                child: Text(
                                                  'سجل',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    height: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: <Widget>[

                                          DropdownButton<String>(
                                            iconSize: 30,
                                              style:TextStyle(color: Colors.red),
                                              items: dropItems.map((String selectItem){
                                                return DropdownMenuItem(
                                                    value: selectItem,
                                                    child: Text(selectItem)
                                                );
                                              }
                                              ).toList(),
                                              isExpanded: false,
                                              dropdownColor: Colors.blue[50],
                                              iconEnabledColor: Colors.red,
                                              icon: Icon(Icons.menu),
                                              onChanged: (String theDate){
                                                setState(() {
                                                  dropSelectItem = theDate;
                                                  if(theDate =='إلتقاط تاريخ اليوم تلقائياً'){
                                                  }else{
                                                    showDatePicker(
                                                        context: context,
                                                        initialDate: DateTime.now(),
                                                        firstDate: DateTime(2020),
                                                        lastDate: DateTime(2222)
                                                    ).then((date){
                                                      setState(() {
                                                        time = DateFormat('yyyy-MM-dd-HH:mm').format(date).toString();
                                                      });
                                                    });
                                                  }
                                                }
                                                );
                                              },
                                            value: dropSelectItem,
                                            elevation: 7,
                                          ),
                                          Text('تحديد التاريخ :',textAlign: TextAlign.center,
                                            style: TextStyle(

                                            )
                                            ,),
                                        ],
                                      ),
                                    ),
                                  ],

                                ),
                              ),

                              Padding(padding: EdgeInsets.only(top: 2)),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                width: 324,
                                height: 59,
                                child: Stack(
                                  children: <Widget>[
                                    CheckboxListTile(
                                      value: checkStatuse,
                                      onChanged: Check,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 248),
                                      child: CheckboxListTile(
                                        value: checkStatuse2,
                                        onChanged: Check2,
                                      ),
                                    ),
                                    Positioned(
                                        right: 22,
                                        bottom: 11,
                                        child: Text(
                                          'يوم',
                                          style: TextStyle(height: -1),
                                        )),
                                    Positioned(
                                        left: 22,
                                        bottom: 11,
                                        child: Text(
                                          'نصف يوم',
                                          style: TextStyle(height: -1),
                                        ))
                                  ],
                                ),
                              ),
                            ]),
                        Padding(padding: EdgeInsets.only(top: 14)),
                        Container(
                          width: 300,
                          height: 6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue),
                        ),
                        Padding(padding: EdgeInsets.only(top:heightScreen>750? 60 :7)),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context, BouncyPageRoute(widget: allYomiat()));
                          },
                          child: Container(
                            width: 300,
                            height: 44,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue),
                            child: Center(
                              child: Text('إذهب الى كل اليوميات',textAlign: TextAlign.center
                              ,style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'AmiriQuran',
                                  height: 1,
                                  color: Colors.white
                                ),),
                            ),
                          ),
                        ),

                        Padding(padding: EdgeInsets.only(top:heightScreen>750? 60 :40)),
                        Padding(
                            padding: EdgeInsets.only(top:heightScreen>750? 60 :7),
                            child: SpinKitFoldingCube(
                              color: Colors.lightBlue,
                              size: 77,
                            )),
                      ],
                    )),
              ]),
            )));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  ShowMessage(){
    Fluttertoast.showToast(msg: 'تم حذف كامل المعلومات',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.grey,
        fontSize: 28,
        textColor: Colors.white
    );
  }
  ShowMessage2(){
    Fluttertoast.showToast(msg: 'قم بإدخال الإسم أولاً',
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 28,
        textColor: Colors.white
    );
  }
  ShowMessage3(){
    Fluttertoast.showToast(msg: 'تم تسجيل اليوميةً',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 28,
        textColor: Colors.white
    );
  }

  var yomReference = FirebaseDatabase.instance.reference();

  DatabaseReference getYomReference() {
    yomReference = yomReference.root();
    return yomReference;
  }

  void addYom(status) {
    Firestore.instance.collection('Yomiat:$tabelNameSet').document().setData({
      'UserName': tabelNameSet,
      'time': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
      'status': status,
      'zoneName':nameZoneSet,
      'name': nameTextController.text

    });
    Timer(Duration(milliseconds: 300),(){
      nameTextController.clear();
      ShowMessage3();
    });
  }
}
