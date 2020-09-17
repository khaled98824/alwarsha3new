import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget{
  final double delay;
  final Widget child;
  FadeAnimation(this.child,this.delay);
  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity").add(Duration(milliseconds: 600), Tween(begin: 0.0,end: 1.0)),
      Track("translatey").add(
          Duration(milliseconds: 500), Tween(begin: 0.0,end: 1.0),
          curve: Curves.bounceInOut
      ),
    ]);
    // TODO: implement build
    return ControlledAnimation(
      delay: Duration(milliseconds: (300*delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild:(context,child,animation)=>Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
          offset:Offset(0, animation["translatey"]),
          child: child,
        ),
      ) ,
    );
  }

}