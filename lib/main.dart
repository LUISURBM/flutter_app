import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/login_page.dart';
import 'package:flutter_app/locator.dart';
import 'package:flutter_app/managers/dialog_manager.dart';
import 'package:flutter_app/themes/doc-theme.dart';
import 'package:flutter_app/themes/elab-themes.dart';
import 'package:flutter_app/ui/router.dart';
import 'package:flutter_app/ui/views/login_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/services/dialog_service.dart';
import 'package:flutter_app/services/navigation_service.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elab app',
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: myTheme,
      home: LoginView(),
      onGenerateRoute: generateRoute,
    );
  }
}
