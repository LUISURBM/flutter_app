import 'package:flutter/foundation.dart';
import 'package:flutter_app/auth0.dart';

class UserRepository {
  static Auth0 auth;
  
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    String token = null;
    try {
      var response = await auth.auth.passwordRealm({
        'username': username,
        'password': password,
        'realm': 'Username-Password-Authentication'
      });
      token = response['access_token'];
    } catch (e) {
      print(e);
    }
    return token;
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return false;
  }
}