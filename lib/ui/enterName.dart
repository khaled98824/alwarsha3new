import 'dart:async';
import 'package:alwarsha3/models/StaticVirables.dart';
import 'package:alwarsha3/ui/frontBage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterName extends StatefulWidget {
  @override
  _EnterNameState createState() => _EnterNameState();
}

String tabelNameSet;
String nameZoneSet;
bool showBTNSave = true;
bool showListZones = false;
bool showText = true;
String zoneText;

var _formKey = GlobalKey<FormState>();
var dropSelectItemZone = dropItemsZone[0];

List<String> dropItemsZone = ['',''];

class _EnterNameState extends State<EnterName> {
  List<String> _list =[];
  String _zoneString = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  getName() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    setState(() {
      _nameController =
          TextEditingController(text: sharedPref.getString('name'));
      dropItemsZone = sharedPref.getStringList('zoneList');
      if (sharedPref.getStringList('zoneList') !=null) {
        setState(() {
          showBTNSave = false;
          showListZones = true;
        });

      } else {
        setState(() {
          showBTNSave = true;
        });

      }
    });

    Timer(Duration(milliseconds: 300), () {
      //tabelNameSet = sharedPref.getString('name');
      print(sharedPref.getString('name').toString());
      //print(sharedPref.getStringList('zoneList'));
    });
  }

  saveName() async {
    tabelNameSet = _nameController.text;
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('name', _nameController.text);
    //sharedPref.setStringList('zoneList', dropItemsZone);
  }

  addZoneToList(){
   // dropItemsZone.add(_zoneController.text);
    _list.add(_zoneString);
    print(_list);
  }
  saveZone() async {
    tabelNameSet = _nameController.text;
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setStringList('zoneList', dropItemsZone);
    print(_zoneController.text);
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _zoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Virables.table = tabelNameSet;
    Virables.zoneName = nameZoneSet;

    return Scaffold(
        body: ListView(
      children: [
        Form(
          key: _formKey,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 40)),
                Center(child: Text('data')),
                Padding(padding: EdgeInsets.only(top: 40)),
                showText? Padding(
                  padding: EdgeInsets.only(right: 20,left: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue[900]),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      child: Text(
                        'قم بادخال اسمك وحاول ان يكون فريداً , ثم اضف منطقة العمل ثم اظغط على زر الدخول',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'AmiriQuran',
                            height: 1.5,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ):Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue[900]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    child: Text(
                      'قم بادخال اسمك وحاول ان يكون فريداً , ثم اضف منطقة العمل ثم اظغط على زر الدخولً',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'AmiriQuran',
                          height: 1.5,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 100)),
                showBTNSave
                    ? Container(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 240,
                              height: 40,
                              child: TextFormField(
                                controller: _nameController,
                                // ignore: missing_return
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Please enter principal amount';
                                  }
                                },
                                maxLines: 2,

                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  hintText: '!...أدخل إسم العامل هنا',
                                  fillColor: Colors.white,
                                  hoverColor: Colors.white,
                                ),
                                cursorRadius: Radius.circular(10),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  saveName();
                                }

                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.blue[900]),
                                  width: 60,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'AmiriQuran',
                                          height: 1,
                                          color: Colors.white),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 30,
                ),
                showListZones
                    ? Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          DropdownButton<String>(
                            iconSize: 30,
                            style: TextStyle(color: Colors.red),
                            items: dropItemsZone.map((String selectItem) {
                              return DropdownMenuItem(
                                  value: selectItem, child: Text(selectItem));
                            }).toList(),
                            isExpanded: false,
                            dropdownColor: Colors.blue[50],
                            iconEnabledColor: Colors.red,
                            icon: Icon(Icons.menu),
                            onChanged: (String theZone) {
                              setState(() {
                                dropSelectItemZone = theZone;
                                nameZoneSet = theZone;
                                print(tabelNameSet);
                              });
                            },
                            value: dropSelectItemZone,
                            elevation: 7,
                          ),
                          Text(
                            ': تحديد موقع العمل ',
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 100,
                ),
                Container(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: 40,
                        child: TextFormField(
                          enabled: true,
                          controller: _zoneController,
                          onChanged: (text){
                            _zoneString =text;
                          },
                          // ignore: missing_return
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter principal amount';
                            }
                          },
                          maxLines: 2,

                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintText: '!...أدخل إسم العامل هنا',
                            fillColor: Colors.white,
                            hoverColor: Colors.white,
                          ),
                          cursorRadius: Radius.circular(10),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          addZoneToList();
                          saveZone();

                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.blue[800]),
                            width: 110,
                            height: 40,
                            child: Center(
                              child: Text(
                                'إضافة ورشة جديدة',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'AmiriQuran',
                                    height: 1,
                                    color: Colors.white),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences sharedPref = await SharedPreferences.getInstance();
                    print(sharedPref.getString('name').toString());
//                    print(sharedPref.getStringList('zoneList'));
//                    print(dropItemsZone.length);
//                    print(dropSelectItemZone);

//                    Navigator.pushReplacement(
//                        context, BouncyPageRoute(widget: FrontBageful()));

                  },
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.blue[800]),
                    child: Center(
                      child: Text(
                        'دخول',
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'AmiriQuran',
                            height: 1,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
