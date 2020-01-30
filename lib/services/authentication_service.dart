import 'package:flutter/foundation.dart';
import 'package:flutter_app/Screens/login_page.dart';
import 'package:flutter_app/auth0.dart';

final String clientId = 'cBY3NoyadShF1Uj5tCur8o7dNz6EkBhr';
final String domain = 'dev-qpdshbe4.auth0.com';

class AuthenticationService {
  final Auth0 auth = Auth0(baseUrl: 'https://$domain/', clientId: clientId);

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var user = await Controller.tryToLogInUserViaAuth(
        auth,
        email,
        password,
      );
      return user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await Controller.tryToSignUpWithEmail(email, password);
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }
}
