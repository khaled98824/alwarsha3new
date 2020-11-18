import 'package:alwarsha3/models/AnimationMethod.dart';
import 'package:alwarsha3/models/StaticVirables.dart';
import 'package:alwarsha3/ui/yomiat.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

import 'dart:math';
import 'Notes.dart';
import 'PageRoute.dart';
import 'aboutApp.dart';
import 'data.dart';
import 'enterName.dart';
import 'guide.dart';
import 'madfoaat.dart';
import 'massrofat.dart';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FrontBageful();
  }
}

class FrontBageful extends StatefulWidget {
  @override
  _FrontBagefulState createState() => _FrontBagefulState();
}

var cardAspectRatio = 10.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;
String buttonTxt = '';
var heightScreen;
String tabelName1;
bool menu = false;

class _FrontBagefulState extends State<FrontBageful> {
 final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  var currentPage = images.length - 1.0;
  getInfoDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var infoData = androidInfo.androidId;
    setState(() {
      info = infoData;
      tabelName1 = info;
    });
  }

  getIosInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    setState(() {
      info = iosInfo.identifierForVendor;
      tabelName1 = info;
    });
  }
  String info = '';

  @override
  void initState() {
    confCalledBack();
    getToken();
    // TODO: implement initState
    super.initState();
    buttonTxt = 'اليوميات';
  }
  void getToken()async{
    String token = await firebaseMessaging.getToken();
  }
  void confCalledBack(){
    firebaseMessaging.configure(
      onMessage: (message)async{
      },
      onResume: (message)async{
      },
      onLaunch: (message)async{
      },
    );
}
  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;
    PageController controller = PageController(initialPage: images.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
        if (currentPage == 0) {
          buttonTxt = 'الملاحظات';
        } else if (currentPage == 1) {
          buttonTxt = 'المدفوعات';
        } else if (currentPage == 2) {
          buttonTxt = 'المصروفات';
        } else if (currentPage == 3) {
          buttonTxt = 'اليوميات';
        }
      });
    });
    Virables.screenSizeHieght = heightScreen;
    Virables.table =tabelName1;
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: Color(0xFF1b1e44),),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top:heightScreen >700 ? 32 : 20,bottom: 8),),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
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
                                Icons.menu,color: Colors.white,size: 40,))),
                      Text(
                        'الورشة',
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontFamily: 'AmiriQuran',
                            height: 1),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>EnterName()));                        },
                          child: Icon(Icons.arrow_forward_ios,color: Colors.white,size: 30,))
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0, right: 12.0,),
                  ),
                  createTextBox(),
                  Stack(
                    children: <Widget>[
                      CardScrollWidget(currentPage),
                      Positioned.fill(
                        child: PageView.builder(
                          itemCount: images.length,
                          controller: controller,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),

                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(bottom:heightScreen>700 ? 23 : 12),
                      child: Container(
                        width: 176,
                        height: 34,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.deepOrangeAccent),
                        child: Center(
                          child: Text(
                            buttonTxt,
                            style: TextStyle(
                              fontSize: 26,
                              fontFamily:'AmiriQuran',
                              height: 1,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (currentPage == 0) {
                        Navigator.push(
                            context,BouncyPageRoute(widget:Notes()));
                      } else if (currentPage == 1) {
                        Navigator.push(
                            context,BouncyPageRoute(widget:Madfoaat()));
                      } else if (currentPage == 2) {
                        Navigator.push(
                            context,BouncyPageRoute(widget:Massrofat()));
                      }else if (currentPage == 3) {
                        Navigator.push(
                            context,BouncyPageRoute(widget:Yomiat()));
                      }
                    },
                  )
                ],
              ),
            ),
            menu ? menuSide():Container()

          ],
        )

      ),
    );
  }
  menuSide(){
    return FadeAnimation( Padding(
      padding: EdgeInsets.only(top: 100),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,

        ),
        height:heightScreen,
        width: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 110,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: Colors.red,
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
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Colors.blue[700],
                  ),
                  child: Center(
                    child: Text('دليل الإستخدام',textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
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
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Colors.blue[700],
                  ),
                  child: Center(
                    child: Text('حول التطبيق',textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily:'AmiriQuran',
                          height: 1,
                          color: Colors.white
                      ),),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 7,
              child: Container(
                width: 110,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Colors.blue,
                ),
              ),
            ),
            Card(
              elevation: 7,
              child: Container(
                width: 110,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Colors.blue,
                ),
              ),
            ),
            Card(
              elevation: 7,
              child: Container(
                width: 110,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Colors.blue,
                ),
              ),
            ),
            heightScreen >720? Card(
              elevation: 7,
              child: Container(
                width: 110,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Colors.blue,
                ),
              ),
            ):Container(),
            heightScreen >720? Card(
              elevation: 7,
              child: Container(
                width: 110,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Colors.blue,
                ),
              ),
            ):Container(),
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
    ),1);

  }
}



createTextBox(){

  if (heightScreen >780){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[900]),
      height: 93,
      width: 364,
      child:
      Padding(
        padding: EdgeInsets.only(top: 1,right: 1,left:1,bottom:1),
        child: Text('قم بإدارة سجلات عملك بطريقة ذكية ومريحة وبكل بساطة , ودون أن تفقد سجلاتك تحت أي ضرف',
          textAlign:TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily:'AmiriQuran',
              height: 2,
              color: Colors.white
        ),),
      ),
    );
  }else{
     return Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
  color: Colors.blueAccent),
  height: 3,
  width: 300
    );
  }
}

class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 14.0;
  var verticalInset = 14.0;
  CardScrollWidget(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 0; i < images.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(images[i], fit: BoxFit.cover),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 1.0),
                              child: Opacity(
                                opacity: 0.8,
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 9,top: 6,bottom: 6,left: 4),
                                    child: Text(title[i],
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                            color: Colors.blue[900],
                                            fontSize: 19.0,
                                            fontFamily: 'AmiriQuran',
                                          height: 1,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}
