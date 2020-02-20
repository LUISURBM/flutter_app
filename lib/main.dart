import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/auth/bloc/authentication_bloc.dart';
import 'package:flutter_app/auth/login/ui/login_page.dart';
import 'package:flutter_app/common/loading_indicator.dart';
import 'package:flutter_app/common/navigation_bloc.dart';
import 'package:flutter_app/locator.dart';
import 'package:flutter_app/managers/dialog_manager.dart';
import 'package:flutter_app/services/dialog_service.dart';
import 'package:flutter_app/services/navigation_service.dart';
import 'package:flutter_app/themes/elab-themes.dart';
import 'package:flutter_app/ui/router.dart';
import 'package:flutter_app/ui/views/home_page.dart';
import 'package:flutter_app/ui/views/splash_page.dart';
import 'package:flutter_app/viewmodels/profile_update.dart';
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
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(builder: (context) => ThemeBloc()),
        BlocProvider<AuthenticationBloc>(
            builder: (context) => authenticationBloc),
        BlocProvider<NavigatorBloc>(builder: (context) => NavigatorBloc(navigatorKey: _navigatorKey)),
      ],
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
      home: WillPopScope(
          onWillPop: () => showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
              title: Text('Warning'),
              content: Text('Do you really want to exit'),
              actions: [
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () => Navigator.pop(c, true),
                ),
                FlatButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(c, false),
                ),
              ],
            ),
          ),
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticationAuthenticated) {
                return Profile();
              }
              if (state is AuthenticationUnauthenticated) {
                return LogInPage();
              }
              if (state is AuthenticationLoading) {
                return LoadingIndicator();
              }
              return SplashPage();
            },
          )),
      onGenerateRoute: generateRoute,
    );
  }
}
