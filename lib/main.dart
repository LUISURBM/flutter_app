import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/auth/bloc/authentication_bloc.dart';
import 'package:flutter_app/auth/login/ui/login_page.dart';
import 'package:flutter_app/locator.dart';
import 'package:flutter_app/managers/dialog_manager.dart';
import 'package:flutter_app/services/dialog_service.dart';
import 'package:flutter_app/services/navigation_service.dart';
import 'package:flutter_app/themes/elab-themes.dart';
import 'package:flutter_app/ui/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  setupLocator();
  runApp(ElabApp());
}

class ElabApp extends StatefulWidget {

  ElabApp({Key key}) : super(key: key);

  @override
  State<ElabApp> createState() => _MyApp();
}


class _MyApp extends State<ElabApp> {
  AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    authenticationBloc = AuthenticationBloc();
    authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    authenticationBloc.dispose();
    super.dispose();
  }

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
      home: BlocProvider<AuthenticationBloc>(
          builder: (context) => AuthenticationBloc()
      ..dispatch(AppStarted()),
      child: LogInPage()),
      onGenerateRoute: generateRoute,
    );
  }
}
