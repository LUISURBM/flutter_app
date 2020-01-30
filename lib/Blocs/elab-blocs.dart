import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_app/auth0.dart';

enum AuthKeys { AUTH0, FACEBOOK}
final String clientId = 'cBY3NoyadShF1Uj5tCur8o7dNz6EkBhr';
final String domain = 'dev-qpdshbe4.auth0.com';

class ElabBlocs with ChangeNotifier {
  // ChangeNotifier : will provide a notifier for any changes in the value to all it's listeners
  bool isDarkMode = false;
  static Auth0 auth = Auth0(baseUrl: 'https://$domain/', clientId: clientId);

  static Auth0 getAuthFromKey(AuthKeys themeKey) {
    switch (themeKey) {
      case AuthKeys.AUTH0:
        return ElabBlocs.auth;
      default:
        return ElabBlocs.auth;
    }
  }
}

@immutable
abstract class AuthEvent extends Equatable {
  // Passing class fields in a list to the Equatable super class
  AuthEvent([List props = const []]) : super(props);
}

class AuthChanged extends AuthEvent {
  final AuthKeys auth;

  AuthChanged({
    @required this.auth,
  }) : super([auth]);
}

@immutable
class AuthState extends Equatable {
  final Auth0 auth;

  AuthState({
    @required this.auth,
  }) : super([auth]);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState =>
      // Everything is accessible from the appThemeData Map.
  AuthState(auth: ElabBlocs.getAuthFromKey(AuthKeys.AUTH0));

  @override
  Stream<AuthState> mapEventToState(
      AuthEvent event,
      ) async* {
    if (event is AuthChanged) {
      yield AuthState(auth: ElabBlocs.getAuthFromKey(event.auth));
    }
  }
}