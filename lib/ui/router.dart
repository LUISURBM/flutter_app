import 'package:flutter_app/auth/login/ui/login_page.dart';
import 'package:flutter_app/auth/login/ui/login_view.dart';
import 'package:flutter_app/ui/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants/route_names.dart';
import 'package:flutter_app/ui/views/signup_view.dart';
import 'package:flutter_app/viewmodels/profile_update.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case LoginPageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LogInPage(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeView(),
      );
    case ProfileUpdateRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: Profile(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
