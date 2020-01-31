import 'package:flutter/material.dart';
import 'package:flutter_app/ui/views/login_page.dart';
import 'package:flutter_app/locator.dart';
import 'package:flutter_app/managers/dialog_manager.dart';
import 'package:flutter_app/themes/doc-theme.dart';
import 'package:flutter_app/themes/elab-themes.dart';
import 'package:flutter_app/ui/router.dart';
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
    return BlocProvider(
      builder: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _buildWithTheme,
      ),
    );
  }

  Widget _buildWithTheme(BuildContext context, ThemeState state) {
    return MaterialApp(
      title: 'Elab app',
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: state.themeData,
      home: LogInPage(),
      onGenerateRoute: generateRoute,
    );

  }
}
