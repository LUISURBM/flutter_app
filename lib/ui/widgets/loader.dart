import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  @override
  State createState() => LoaderState();
}

class LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    animation.addListener(() {
      this.setState(() {});
    });
    animation.addStatusListener((AnimationStatus status) {});
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          color: Colors.blue,
          height: 3.0,
          width: animation.value * 100.0,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5.0),
        ),
        Container(
          color: Colors.blue[300],
          height: 3.0,
          width: animation.value * 75.0,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5.0),
        ),
        Container(
          color: Colors.blue,
          height: 3.0,
          width: animation.value * 50.0,
        )
      ],
    );
  }
}


/*
Expanded(
child: Padding(
padding:
EdgeInsets.only(left: 20.0, right: 5.0, top:20.0),
child: GestureDetector(
onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => FirstScreen()));
},
child: Container(
alignment: Alignment.center,
height: 45.0,
decoration: BoxDecoration(
color: Color(0xFF1976D2),
borderRadius: BorderRadius.circular(9.0)),
child: Text('Login',
style: TextStyle(
fontSize: 20.0, color: Colors.white))),
),
),
),*/
