library auth0_auth;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_app/env/env-auth.dart';
import 'package:http/http.dart' as http;

part 'exception/auth_exeption.dart';
part 'exception/auth0_error.dart';
part 'Objects/user_info.dart';
part 'auth/index.dart';
part 'webauth/index.dart';
part 'networking/client.dart';
part 'networking/telemetry.dart';
part 'management/users.dart';

class Auth0 {
  final Auth0Auth auth;
  final WebAuth webAuth;
  final dynamic options;

  Auth0._(this.auth, this.webAuth, this.options);

  static Auth0 init() {
    final auth = envAuth();

    return Auth0(baseUrl: 'https://dev-qpdshbe4.auth0.com/', clientId: 'cBY3NoyadShF1Uj5tCur8o7dNz6EkBhr');
  }
  factory Auth0({String baseUrl, String clientId}) {
    assert(baseUrl != null && clientId != null);
    final auth = Auth0Auth(clientId, baseUrl);
    final webAuth = new WebAuth(auth);
    return Auth0._(auth, webAuth, envAuth);
  }

  /*
   * Creates a Users API client
   * https://manage.auth0.com/#/apis/management/explorer
   * @param  {String} token for Management API
   * @return {Users}
   */
  Users users(String token) {
    return Users(Map.from(this.options)..addAll({'token': token}));
  }
}