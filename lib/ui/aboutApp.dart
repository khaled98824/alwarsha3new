import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'frontBage.dart';
class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AboutApp();
  }
}

class AboutApp extends StatefulWidget {
  @override
  _AboutApp createState() => _AboutApp();
}

class _AboutApp extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        title: Text('حول التطبيق',
          style: TextStyle(
            fontSize: 34,
            height: 1,
            fontFamily: 'AmiriQuran',
          ),),
      ),
      body: ListView(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                color: Color(0xFF1b1e44),),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top:heightScreen>750? 24 :20,bottom: 14),
                      child: SpinKitFoldingCube(
                        color: Colors.lightBlue,
                        size: 60,
                        duration: Duration(seconds: 3),
                      )),
                  Container(
                    height: 4,
                    width:340 ,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.blue
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('- تطبيق الورشة تطبيق مبسط للقيام بعمليات إدارة سجلات العمل وذلك للأعمال التي تدار بشكل يومي الهدف منه تسهيل وتطوير عملية تسجيل المعلومات في العمل وخدمة اصحاب الأعمال بشكل عام ,\n وايضاً عمال الورش يستطيعون إستخدام التطبيق والإستفادة منه , فهو يحفظ سجلات اي شخص يستخدمه ويمكنه من  مراجعتها وإدارتها .',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 22,
                          height: 2,
                          fontFamily: 'AmiriQuran',
                          color: Colors.black
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('- كما تخُزن جميع سجلات المستخدم على الشبكة وتحفظ من الضياع, وحتى في حال حذف التطبيق أو تبديل جهاز الموبايل يمكن للمستخدم إستعادة كل سجلاته وذلك فقط بمراسلة مطور التطبيق .',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 22,
                          height: 2,
                          fontFamily: 'AmiriQuran',
                            color: Colors.black

                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('- من الأهداف الأساسية لإنشاء تطبيق الورشة دعم وجود حقيقي للتطبيقات العربية للمبرمجين العرب , واثبات ان للمبرمجين العرب بصمة واضحة في مجال البرمجة حتى وان كان التطبيق ليس بتلك الضخامة لكنه  إنشأ  لهدف عملي وهو جزء من عدة تطبيقات وبرامج اخرى .',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 22,
                          height: 2,
                          fontFamily: 'AmiriQuran',
                            color: Colors.black

                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('للتواصل مع مطور التطبيق : khaled_salehalali@hotmail.com',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 22,
                          height: 2,
                          fontFamily: 'AmiriQuran',
                            color: Colors.black

                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      )

    ),
    );

  }
}
