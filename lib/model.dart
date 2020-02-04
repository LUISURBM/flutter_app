
import 'package:flutter_app/locator.dart';
import 'package:flutter_app/services/navigation_service.dart';

class Model {
  static final NavigationService _navigationService = locator<NavigationService>();

  static String _logoTitle = "Elab Mobile";
  static String _logoSubTitle = "OnGo Technologies";
  static String _signInMenuButton = "SIGN IN";
  static String _signUpMenuButton = "SIGN UP";
  static String _hintTextEmail = "Email";
  static String _hintTextPassword = "Password";
  static String _hintTextNewEmail = "Enter your Email";
  static String _hintTextNewPassword = "Enter a Password";
  static String _signUpButtonText = "SIGN UP";
  static String _signInWithAuth0ButtonText = "Sign in with Auth";
  static String _signInWithEmailButtonText = "Sign in with Email";
  static String _signInWithFacebookButtonText = "Sign in with Facebook";
  static String _alternativeLogInSeparatorText = "or";
  static String _emailLogInFailed =
      "Email or Password was incorrect. Please try again";

  static void _changeToSignUp() {
    _signUpActive = true;
    _signInActive = false;
  }

  static void _changeToSignIn() {
    _signUpActive = false;
    _signInActive = true;
  }

  static Future<Post> _signInWithAuth(Auth0 auth, String email, String password) async {
    Post post = new Post();
    try {
      var response = await auth.auth.passwordRealm({
        'username': email.trim().toLowerCase(),
        'password': password,
        'realm': 'Username-Password-Authentication'
      });
      post.email = 'luiz-felipe16@hotmail.com';
      post.token = response['access_token'];
    } catch (e) {
      print(e);
    }
    return post;
  }

  static Future<Post> _signInWithFacebook(Auth0 auth, context) async {
    Post post = await fetchPost();
    try {
      var response = await auth.auth.passwordRealm({
        'username': 'luiz-felipe16@hotmail.com',
        'password': '20auth.0129.',
        'realm': 'Username-Password-Authentication'
      });
      post.token = response['access_token'];
    } catch (e) {
      print(e);
    }
    if (post != null) {
      print('Successfully signed in with Facebook. ');
      return post;
    } else {
      print('Failed to sign in with Facebook. ');
      return null;
    }
  }

  static Future _navigateToProfile(post) async {
    await _navigationService.navigateTo(ProfileUpdateRoute);
  }
}
