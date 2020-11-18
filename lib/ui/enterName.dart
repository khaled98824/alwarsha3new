import 'dart:async';
import 'dart:io';
import 'package:alwarsha3/models/AnimationMethod.dart';
import 'package:alwarsha3/models/StaticVirables.dart';
import 'package:alwarsha3/ui/EnterToOldZone.dart';
import 'package:alwarsha3/ui/PageRoute.dart';
import 'package:alwarsha3/ui/aboutApp.dart';
import 'package:alwarsha3/ui/frontBage.dart';
import 'package:alwarsha3/ui/guide.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class EnterName extends StatefulWidget {
  @override
  _EnterNameState createState() => _EnterNameState();
}
var heightScreen2;

bool menu = false;
bool checkboxVal = false;
bool checkLogin= false;
bool autoLogin = false;
bool showAddZone =false;
String tabelNameSet;
String nameZoneSet;
bool showBTNSave = true;
bool showBTNsaveZone = true;
bool showZoneTxtFiled =true;
bool showListZones = false;
bool showText = true;
bool showButtonEnter=false;
bool showBtnEnter2 = false;
String zoneText;
DocumentSnapshot usersList;
bool equalZone ;
bool equalName ;
bool showSliderAds = false;
DocumentSnapshot documentsUrlsAds ;
var adImagesUrlF = List<dynamic>();

var _formKey = GlobalKey<FormState>();
var dropSelectItemZone = 'إختر الورشة';
List<String> dropItemsZone = [dropSelectItemZone,];

class _EnterNameState extends State<EnterName> {
  List<String> _list =[];
  List<String> _listUsers =[];
  List<String> _listZones =[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
    getDocumentValue();
    getUrlsForAds();
  }
  getUrlsForAds() async {
    DocumentReference documentRef = Firestore.instance
        .collection('UrlsForInfo')
        .document('gocqpQlhow2tfetqlGpP');
    documentsUrlsAds = await documentRef.get();
    adImagesUrlF = documentsUrlsAds.data['urls'];
    setState(() {
      showSliderAds = true;
      showText = false;
    });}
   Future getDocumentValue()async{
    DocumentReference documentRef =Firestore.instance.collection('Zones').document();
    usersList = await documentRef.get();
   var firestore = Firestore.instance;
   QuerySnapshot qus = await firestore.collection('Zones').where('UserName',isEqualTo: _nameController.text).getDocuments();
   if(qus!=null){
   for (int i=0; qus.documents.length>_list.length;  i ++){
     setState(() {
       _list.add(qus.documents[i]['Zone']);

     });
   }}

    QuerySnapshot qusListUsers = await firestore.collection('Users').getDocuments();
   if(qusListUsers!=null){
   for (int i=0; qusListUsers.documents.length>_listUsers.length;  i ++){
      setState(() {
        _listUsers.add(qusListUsers.documents[i]['UserName']);

      });
    }}

    QuerySnapshot qusListZones = await firestore.collection('Zones').where('UserName',isEqualTo:_nameController.text).getDocuments();

    if(qusListZones!=null){
      for (int i=0; qusListZones.documents.length>_listZones.length;  i ++){
      setState(() {
        _listZones.add(qusListZones.documents[i]['Zone']);
      });
    }}

    dropItemsZone.addAll(_list);
   setState(() {
     Timer(Duration(microseconds: 100),(){
       if(_listZones.length>0){
         showListZones = true;
       }


     });
     tabelNameSet=_nameController.text;
   });
   return qus.documents;

  }

  getName() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    setState(() {
      _nameController =
          TextEditingController(text: sharedPref.getString('name'));
          _zoneController = TextEditingController(text: sharedPref.getString('zoneList'));
          _nameController=TextEditingController(text: sharedPref.getString('name'));

    });


  }

  saveName() async {
    tabelNameSet = _nameController.text;
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('name', _nameController.text);

    if (_formKey.currentState.validate()) {
      Firestore.instance.collection('Users').document(_nameController.text).setData({
        'UserName': _nameController.text.toLowerCase().trimLeft(),
        'time': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
      });
      setState(() {
        showBTNSave =false;
      });
    }
  }

  saveZone() async {
    tabelNameSet = _nameController.text;
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('zoneList', _zoneController.text);
    if (_formKey.currentState.validate()) {
      Firestore.instance.collection('Zones').document().setData({
        'UserName': _nameController.text.toLowerCase().trimLeft(),
        'Zone': _zoneController.text.toLowerCase().trimLeft(),
        'time': DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now()),
      });}
    setState(() {
      dropItemsZone.add(_zoneController.text);
      tabelNameSet = _nameController.text;
      showListZones =true;
      showAddZone =false;
    });
    Timer(Duration(microseconds: 400),(){
      _zoneController.clear();
    });
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _zoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    heightScreen2 = MediaQuery.of(context).size.height;
    Virables.table = tabelNameSet;
    Virables.zoneName = nameZoneSet;

    return Scaffold(
        body: SafeArea(
          child:Stack(
            children: [
              ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          if(menu){
                                            menu = false;
                                          }else{
                                            menu = true;
                                          }
                                          Timer(Duration(seconds: 6),(){
                                            setState(() {
                                              menu = false;
                                            });
                                          });
                                        });
                                      },
                                      child: Icon(
                                        Icons.menu,color: Colors.black,size: 30,))),
                              Text('مرحبا بك في تطبيق الورشة',style: TextStyle(
                                  fontSize: 21,
                                  fontFamily: 'AmiriQuran',
                                  height: 1.5,
                                  color:Colors.blue[900]),),

                              SizedBox(width: 5,)

                            ],
                          ),

                          Padding(padding: EdgeInsets.only(top: 25)),
                          showText? Padding(
                            padding: EdgeInsets.only(right: 20,left: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue[900]),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                                child: Text(
                                  'قم بادخال اسمك ثم اظغط زر حفظ - \n ثم اضف منطقة العمل - \nثم اظغط على زر الدخول -',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'AmiriQuran',
                                      height: 1.5,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ):areaForInfo(),
                          Padding(padding: EdgeInsets.only(top: 90)),
                          Container(
                            width: 350,height: 2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey[600]
                            ),
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: 240,
                                  height: 46,
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
                                      hintText: '!...أدخل إسمك',
                                      fillColor: Colors.white,
                                      hoverColor: Colors.white,
                                    ),
                                    cursorRadius: Radius.circular(10),
                                    onChanged: (a){
                                      setState(() {
                                        showBTNSave =true;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                showBTNSave ? InkWell(
                                  onTap: () {
                                    if (_formKey.currentState.validate()) {
                                      doSaveName();
                                    }

                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.blue[900]),
                                      width: 55,
                                      height: 35,
                                      child: Center(
                                        child: Text(
                                          'حفظ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'AmiriQuran',
                                              height: 1,
                                              color: Colors.white),
                                        ),
                                      )),
                                ):Container(),
                                SizedBox(width: 20,)
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          Container(
                            width: 350,height: 2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey[600]
                            ),
                          ),
                          SizedBox(height: 5,),
                          showAddZone ?Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                showZoneTxtFiled ? Container(
                                  width: 180,
                                  height: 46,
                                  child: TextFormField(
                                    enabled: true,
                                    controller: _zoneController,
                                    // ignore: missing_return
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Please enter principal amount';
                                      }
                                    },
                                    maxLines: 1,


                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                        hintText: '!...أدخل إسم الورشة هنا',

                                        fillColor: Colors.white,
                                        hoverColor: Colors.green,
                                        enabled: true
                                    ),
                                    cursorRadius: Radius.circular(10),
                                  ),
                                ):Container(),
                                SizedBox(
                                  width: 10,
                                ),

                                showBTNsaveZone ? InkWell(
                                  onTap: () {
                                    if(_formKey.currentState.validate()){
                                      doSaveZone();
                                    }
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.blue[900]),
                                      width: 110,
                                      height: 35,
                                      child: Center(
                                        child: Text(
                                          'إضافة ورشة جديدة',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'AmiriQuran',
                                              height: 1,
                                              color: Colors.white),
                                        ),
                                      )),
                                ):Container(),
                                SizedBox(width: 20,)
                              ],
                            ),
                          ):    InkWell(
                            onTap: (){
                              setState(() {
                                showAddZone =true;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'إضافة ورشة جديدة',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'AmiriQuran',
                                      height: 1,
                                      color: Colors.green[800]),
                                ),
                                Icon(Icons.add_circle_outline,color: Colors.green[800],size: 24,),

                                SizedBox(width: 10,)
                              ],
                            ),
                          ),
                          SizedBox(height:5,),
                          Container(
                            width: 350,height: 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey[600]
                            ),
                          ),
                          SizedBox(height: 10,),
                          showListZones ? Card(
                            color: Colors.grey[300],
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  DropdownButton<String>(
                                    iconSize: 24,
                                    style: TextStyle(color: Colors.blue[900],),
                                    items: dropItemsZone.map((String selectItem) {
                                      return DropdownMenuItem(
                                          value: selectItem, child: Text(selectItem));
                                    }).toList(),
                                    isExpanded: false,
                                    dropdownColor: Colors.blue[50],
                                    iconEnabledColor: Colors.blue[900],
                                    icon: Padding(
                                        padding:EdgeInsets.only(left:3),
                                        child: Icon(Icons.menu)),
                                    onChanged: (String theZone) {
                                      setState(() {
                                        _zoneController = TextEditingController(text:theZone);
                                        if(autoLogin){

                                        }else{
                                          showButtonEnter = true;
                                        }
                                        dropSelectItemZone = theZone;
                                        nameZoneSet = theZone;
                                        tabelNameSet = _nameController.text;
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
                            ),
                          ):Container(),

                          SizedBox(
                            height:50,
                          ),
                          showButtonEnter? InkWell(
                            onTap: () async {
                              dropItemsZone.clear();
                              if(_formKey.currentState.validate()){
                                setState(() {
                                  nameZoneSet =_zoneController.text;
                                  tabelNameSet = _nameController.text;
                                });
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>FrontBageful()));

                              }

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
                          ):Container(),
                          showBtnEnter2? Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: InkWell(
                              onTap: () async {
                                if(_formKey.currentState.validate()){
                                  setState(() {
                                    nameZoneSet =_zoneController.text;
                                    tabelNameSet = _nameController.text;
                                  });
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FrontBageful()));

                                }

                              },
                              child: Container(
                                width: 90,
                                height: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.blue[900]),
                                child: Center(
                                  child: Text(
                                    '2 دخول',textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'AmiriQuran',
                                        height: 1,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ):Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              menu? menuSide():Container()

            ],
          )


        ));
  }
  doSaveZone(){
    equalZone=false;
    for(int i=0;i<_listZones.length;i++){
      if(_zoneController.text.toLowerCase().trimLeft()==_listZones[i]){
        equalZone=true;
        showMessage('إسم الورشة موجود مسبقاً رجاءاٌ اختر غيره');
      }
    }
    print(equalZone);
    print(_listZones);
    if(equalZone==false){
      print('done');
      saveZone();
    }
  }

  doSaveName(){
    equalName=false;
    for(int i=0;i<_listUsers.length;i++){
      if(_nameController.text.toLowerCase().trimLeft()==_listUsers[i]){
        equalName=true;
        showMessage('إسم المستخدم موجود مسبقاً رجاءاٌ اختر غيره');
      }
    }
    print(equalName);
    print(_listUsers);
    if(equalName==false){
      print('done');
      dropItemsZone.clear();
      dropItemsZone.add(dropSelectItemZone);
      saveName();
    }
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
        });
      });
    }
  }
  menuSide(){
    return FadeAnimation( Padding(
      padding: EdgeInsets.only(top: 50),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,

        ),
        height:300,
        width: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 140,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: Colors.red,
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                    context,BouncyPageRoute(widget:EnterToOld()));
              },
              child: Card(
                elevation: 7,
                child: Container(
                  width: 140,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue[700],
                  ),
                  child: Center(
                    child: Text('الدخول لورشة موجودة مسبقاً',textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily:'AmiriQuran',
                          height: 1,
                          color: Colors.white
                      ),),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                    context,BouncyPageRoute(widget:Guide()));
              },
              child: Card(
                elevation: 7,
                child: Container(
                  width: 110,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue[700],
                  ),
                  child: Center(
                    child: Text('دليل الإستخدام',textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily:'AmiriQuran',
                          height: 1,
                          color: Colors.white
                      ),),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                    context,BouncyPageRoute(widget:About()));
              },
              child: Card(
                elevation: 7,
                child: Container(
                  width: 110,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue[700],
                  ),
                  child: Center(
                    child: Text('حول التطبيق',textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily:'AmiriQuran',
                          height: 1,
                          color: Colors.white
                      ),),
                  ),
                ),
              ),
            ),

            Container(
              width: 110,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    ),0.2);

  }
showMessage(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.blue,
      fontSize: 15,
      textColor: Colors.white);
}
  Widget areaForInfo() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Swiper(
            itemBuilder: (BuildContext context, int index) {
              return  InkWell(
                onTap: (){

                },
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:Hero(
                      tag: Text('imageAd'),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.network(
                            adImagesUrlF[index],
                            fit: BoxFit.fill,
                            // height: 75,
                            // width: 390,
                          ))),
                ),
              );

            },
            scrollDirection: Axis.horizontal,
            itemCount: adImagesUrlF.length,
            itemWidth:MediaQuery.of(context).size.width -20 ,
            itemHeight: 150,
            duration: 2000,
            autoplayDelay: 14000,
            autoplay: true,
            //pagination: new SwiperPagination(),
            layout: SwiperLayout.STACK,
          ),

        ]);
  }
}