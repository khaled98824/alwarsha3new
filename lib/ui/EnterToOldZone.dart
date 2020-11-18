import 'dart:async';

import 'package:alwarsha3/models/StaticVirables.dart';
import 'package:alwarsha3/ui/PageRoute.dart';
import 'package:alwarsha3/ui/frontBage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EnterToOld extends StatefulWidget {
  @override
  _EnterToOldState createState() => _EnterToOldState();
}
bool showListZones = false ;
bool showBTNEnter = false ;
String tabelNameSet;
String nameZoneSet;
var dropSelectItemZone = 'إختر الورشة';
List<String> dropItemsZone = [dropSelectItemZone,];

TextEditingController _nameController = TextEditingController();
TextEditingController _zoneController = TextEditingController();
var _formKey = GlobalKey<FormState>();

class _EnterToOldState extends State<EnterToOld> {
  @override
  Widget build(BuildContext context) {
    Virables.table = tabelNameSet;
    Virables.zoneName = nameZoneSet;
    return Scaffold(
      appBar: AppBar(
        title: Text('الدخول لورشة موجودة مسبقاً',style: TextStyle(
            fontSize: 17,
            fontFamily: 'AmiriQuran',
            color: Colors.white),),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(right: 10,left: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.blue[900]),
                
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 4),
                    child: Text(
                      'أدخل اسم المستخدم الخاص بالورشة التي تريد الدخول إليها \n\nثم أدخل إسم الورشة واظغط زر دخول',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          letterSpacing: 1,
                          wordSpacing: 1,
                          color: Colors.white),
                    ),
                  ),
                )),
            SizedBox(
              height: 70,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Container(
                  width: 220,
                  height: 37,
                  child: TextFormField(
                    controller: _nameController,
                    // ignore: missing_return
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter principal amount';
                      }
                    },

                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: '!...أدخل إسم المستخدم',
                      hintStyle: TextStyle(
                          fontSize: 16,
                          height: 1
                      ),
                      fillColor: Colors.white,
                      hoverColor: Colors.white,
                    ),
                    cursorRadius: Radius.circular(10),
                    onChanged: (a) {
                      setState(() {

                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: (){
                    getListZones();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue[900]),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6,horizontal: 7),
                        child: Text('تحقق', textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'AmiriQuran',
                              height: 1,
                              color: Colors.white),)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            showListZones ? Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: <Widget>[
                  DropdownButton<String>(
                    iconSize: 30,
                    style: TextStyle(color: Colors.blue[900],),
                    items: dropItemsZone.map((String selectItem) {
                      return DropdownMenuItem(
                          value: selectItem, child: Text(selectItem));
                    }).toList(),
                    isExpanded: false,
                    dropdownColor: Colors.blue[50],
                    iconEnabledColor: Colors.blue[900],
                    icon: Padding(
                        padding:EdgeInsets.only(left: 3),
                        child: Icon(Icons.menu)),
                    onChanged: (String theZone) {
                      setState(() {
                        _zoneController = TextEditingController(text:theZone);
                        dropSelectItemZone = theZone;
                        nameZoneSet = theZone;
                        tabelNameSet = _nameController.text;
                        showBTNEnter = true ;
                      });
                    },
                    value: dropSelectItemZone,
                    elevation: 7,
                  ),
                  Text(
                    ': تحديد موقع العمل ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'AmiriQuran',
                        height: 1,
                        color: Colors.black),
                  ),
                ],
              ),
            ):Container(),
            SizedBox(
              height: 20,
            ),

            SizedBox(height: 40,),

            showBTNEnter ? InkWell(
              onTap: (){
                enter();
              },
              child: Container(
                margin: EdgeInsets.only(right: 50,left: 50),
                width: 200,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.blue[900]),
                  child: Center(
                    child: Text(
                      'دخول',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AmiriQuran',
                          height: 1,
                          color: Colors.white),
                    ),
                  )),
            ):Container(),
          ],
        ),
      ),
    );
  }
  enter()async{
    setState(() {
      nameZoneSet =_zoneController.text;
      Navigator.push(context, BouncyPageRoute(widget:MyApp()));
    });
  }

  getListZones()async{
    var firestore = Firestore.instance;
    List<String> _listZones2 =[];
    QuerySnapshot qusListZones = await firestore.collection('Zones').where('UserName',isEqualTo:_nameController.text).getDocuments();
    if(qusListZones!=null){
      for (int i=0; qusListZones.documents.length>_listZones2.length;  i ++){
        setState(() {
          _listZones2.add(qusListZones.documents[i]['Zone']);
        });
      }
      print("==z $_listZones2");
      Timer(Duration(microseconds: 300), (){
        setState(() {
          // dropItemsZone.clear();
          dropItemsZone.addAll(_listZones2);
          showListZones = true;
        });
      });
    }
  }
}
