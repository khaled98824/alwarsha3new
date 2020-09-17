import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'frontBage.dart';

class Guide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GuideF();
  }
}

class GuideF extends StatefulWidget {
  @override
  _GuideF createState() => _GuideF();
}

class _GuideF extends State<GuideF> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('دليل المستخدم',
              style: TextStyle(
                fontSize: 32,
                height: 1,
                fontFamily: 'AmiriQuran',
              ),),
          ),
          body: ListView(
            children: <Widget>[
              Container(
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
                          child: Text('- إستخدام تطبيق الورشة لا يتطلب من المستخدم اي عملية تسجيل او ادخال بيانات خاصه عن هوية المستخدم , فقط افتح التطبيق ثم ابدأ بأستخدام التطبيق في تسجيل معلومات العمل دون اشتراطات وسيقوم التطبيق تلقائياً بانشاء جداول خاصة بسجلاتك مرفوعه على الشبكة غير قابلة للإزاله الا من قبلك انت كمستخدم .',
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
                          child: Text('- تسجيل اليوميات :\n-- قم بالدخول الى واجهة اليوميات ثم اخل اسم العامل في الحقل المخصص وحدد في ما اذا كان يوم او نصف يوم وبالنسبة للتاريخ يمكنك ترك التطبيق يقوم بالتقاط تاريخ اليوم تلقائياً او تقوم انت بتحديد التاريخ يدوياً , ثم اظغط على زر سجل وبذلك تكون قد سجلت اليومية للعامل بسجل يوميات خاص بك مرفوع على الشبكة ومحفوظ من الضياع .\n\n-- في حال اردت رؤية كل اليوميات فقط اظغط على زر كل اليوميات .\n\n-- ان اردت رؤية مجموع يوميات العامل "محمد" مثلاً فقط قم بالظغط على اسمة وستنتقل الى واجهة فيها كل يومياته.\n\n-- لحذف كامل اليوميات لعامل معين من واجهة يومياته اظغط بإستمرار على زر حذف الكل .\n-- لحذف يومية واحدة اظغط بإستمرار على أيقونة سلة المحذوفات .\n\n(ملاحظة : بعد الحذف يتطلب منك الرجوع الة واجهة تسجيل اليوميات حتى تزول اليوميات المحذوفة من قائمة كل اليوميات)',
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
                          child: Text('- تسجيل المصروفات :\n-- لتسجيل مصروفاتك اليومية ادخل الى واجهة المصروفات ثم ادخل المبلغ المراد تسجيلة ثم اظغط على زر سجل , وسيلتقط التطبيق تاريخ ووقت التسجيل ويضعه لهذا المبلغ الذي قمت بتسجيلة ,بهذا تكون قد سجلت مبلغ المصروفات في سجل خاص بك مرفوع على الشبكة ومحفوظ من الضياع .\n\n-- لعرض كل المصروفات ورؤية مجموعها اظغط على زر "إذهب الى كل المصروفات" .\n\n-- للحذف اظغط بإستمرار على ايقونة سلة المحذوفات لكل تسجيله .',
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
                          child: Text('تسجيل المدفوعات :\n-- لتسجيل الدفعة قم بإدخال اسم المستلم في الحقل المخصص ثم إدخل مبلغ الدفعة ايضاً في الحقل المخصص ويمكنك جعل التاريخ يلتقط تلقائياً او قم بتحديده يدوياً ثم اظغط على زر سجل , بهذا تكون قد سجلت الدفعة بسجل خاص بدفعاتك مرفوع على الشبكة ومحفوظ من الضياع .\n\n-- لعرض قائمة جميع الدفعات اظغط على زر كل الدفعات .\n\n-- لعرض دفعات شخص معين ومجموع قيمتها فقط اظغط على اسم هذا الشخص من القائمة .\n\n-- لحذف الدفعات لشخص معين اظغط على اسمه ستظهر لك قائمة بجميع الدفعات التي استلمها , ثم اظغط أستمرار على زر حذف الكل .',
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
                          child: Text('لإستعادة سجلاتك في حال  قمت بحذف التطبيق او شراء جهاز هاتف ذكي جديد فقط قم بجلب رقم السيريال لجهازك الذي قمت باستخدام التطبيق عليه وقم بمراسلة مطور التطبيق .\n للتواصل مع مطور التطبيق : khaled_salehalali@hotmail.com',
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
