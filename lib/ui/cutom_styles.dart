import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class CustomTextStyle {
  static TextStyle formField(BuildContext context) {
    return Theme.of(context).textTheme.display1;
  }

  static TextStyle title(BuildContext context) {
    return Theme.of(context).primaryTextTheme.display2;
  }

  static TextStyle subTitle(BuildContext context) {
    return Theme.of(context).primaryTextTheme.display1;
  }

  static TextStyle button(BuildContext context) {
    return Theme.of(context).textTheme.button;
  }

  static TextStyle body(BuildContext context) {
    return Theme.of(context).textTheme.title;
  }
}