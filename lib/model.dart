import 'package:flutter_app/auth0.dart';
import 'package:flutter_app/constants/route_names.dart';
import 'package:flutter_app/locator.dart';
import 'package:flutter_app/model/post.dart';
import 'package:flutter_app/services/navigation_service.dart';
import 'package:flutter_app/auth/login/ui/login_page.dart';
import 'package:mvc_pattern/mvc_pattern.dart';


class Controller extends ControllerMVC {
  /// Singleton Factory
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  }

  static Controller _this;

  Controller._();

  /// Allow for easy access to 'the Controller' throughout the application.
  static Controller get con => _this;

  /// The Controller doesn't know any values or methods. It simply handles the communication between the view and the model.

  static String get displayLogoTitle => Model._logoTitle;

  static String get displayLogoSubTitle => Model._logoSubTitle;

  static String get displaySignUpMenuButton => Model._signUpMenuButton;

  static String get displaySignInMenuButton => Model._signInMenuButton;

  static String get displayHintTextEmail => Model._hintTextEmail;

  static String get displayHintTextPassword => Model._hintTextPassword;

  static String get displayHintTextNewEmail => Model._hintTextNewEmail;

  static String get displayHintTextNewPassword => Model._hintTextNewPassword;

  static String get displaySignUpButtonTest => Model._signUpButtonText;

  static String get displaySignInAuth0Button =>
      Model._signInWithAuth0ButtonText;

  static String get displaySignInEmailButton =>
      Model._signInWithEmailButtonText;

  static String get displaySignInFacebookButton =>
      Model._signInWithFacebookButtonText;

  static String get displaySeparatorText =>
      Model._alternativeLogInSeparatorText;

  static String get displayErrorEmailLogIn => Model._emailLogInFailed;

  static Future<Post> signInWithAuth(email, password) =>
      Model._signInWithAuth(email, password);

  static Future<Post> signInWithFacebook(context) =>
      Model._signInWithFacebook(context);

  static Future navigateToProfile(post) =>
      Model._navigateToProfile(post);

  static Future navigateTo(route) =>
      Model._navigateTo(route);

  static Future tryToLogInUserViaAuth(
      email, password) async {
    Post post = await signInWithAuth(email, password);
    if (post != null) {
      navigateToProfile(post);
    }
  }

  static Future tryToLogInUserViaFacebook(context) async {
    Post post = await signInWithFacebook(context);
    if (post != null) {
      navigateToProfile(post);
    }
  }

  static Future tryToSignUpWithEmail(email, password) async {
    if (await tryToSignUpWithEmail(email, password) == true) {
      //TODO Display success message or go to Login screen
    } else {
      //TODO Display error message and stay put.
    }
  }

  static Future tryToLogOut() async {
    navigateTo(LoginPageRoute);
  }
}


class Model {

  static final NavigationService _navigationService = locator<NavigationService>();

  static String _logoTitle = "Elab Mobile";
  static String _logoSubTitle = "OnGo Technologies";
  static String _signInMenuButton = "SIGN IN";
  static String _signUpMenuButton = "SIGN UP";
  static String _hintTextEmail = "Enter your Email";
  static String _hintTextPassword = "Enter your Password";
  static String _hintTextNewEmail = "Enter your Email";
  static String _hintTextNewPassword = "Enter a Password";
  static String _signUpButtonText = "SIGN UP";
  static String _signInWithAuth0ButtonText = "Sign in with password";
  static String _signInWithEmailButtonText = "Sign in with Email";
  static String _signInWithFacebookButtonText = "Sign in with Facebook";
  static String _alternativeLogInSeparatorText = "or";
  static String _emailLogInFailed =
      "Email or Password was incorrect. Please try again";

  static Future<Post> _signInWithAuth(String email, String password) async {
    Post post = new Post();
    try {
      var response = await Auth0.init().auth.passwordRealm({
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

  static Future<Post> _signInWithFacebook(context) async {
    Post post = await fetchPost();
    try {
      var response = await Auth0.init().auth.passwordRealm({
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
    await _navigationService.navigateTo(ProfileUpdateRoute, arguments: post);
  }
  static Future _navigateTo(route) async {
    await _navigationService.navigateTo(route);
  }

}