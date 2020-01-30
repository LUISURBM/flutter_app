import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/Screens/home_page.dart';
import 'package:flutter_app/constants/route_names.dart';
import 'package:flutter_app/locator.dart';
import 'package:flutter_app/services/navigation_service.dart';
import 'package:flutter_app/themes/elab-themes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/CustomIcons.dart';
import 'package:flutter_app/Screens/profile.dart';
import 'package:flutter_app/Widgets/SocialIcons.dart';
import 'package:flutter_app/auth0.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

bool _signUpActive = false;
bool _signInActive = true;
var facebookLogin = FacebookLogin();
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _newEmailController = TextEditingController();
TextEditingController _newPasswordController = TextEditingController();
final String clientId = 'cBY3NoyadShF1Uj5tCur8o7dNz6EkBhr';
final String domain = 'dev-qpdshbe4.auth0.com';
enum MyThemeKeys { SELF, ALT }

Future<Post> fetchPost() async {
  final response =
  await http.get('https://jsonplaceholder.typicode.com/posts/1');
  Post post;
  if (response.statusCode == 200) {
    // Si la llamada al servidor fue exitosa, analiza el JSON
    post = Post.fromJson(json.decode(response.body));
  } else {
    // Si la llamada no fue exitosa, lanza un error.
    throw Exception('Failed to load post');
  }
  return post;
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;
  String email;
  String token;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class _LogInPageState extends StateMVC<LogInPage> {
  _LogInPageState() : super(Controller());
  Auth0 auth;

  // For CircularProgressIndicator.
  bool visible = false;

  @override
  void initState() {
    auth = Auth0(baseUrl: 'https://$domain/', clientId: clientId);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
    ScreenUtil(width: 750, height: 1304, allowFontScaling: true)
      ..init(context);
    return Column(
      children: <Widget>[
        Container(
          child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Controller.displayLogoTitle,
                    style: CustomTextStyle.title(context),
                  ),
                  Text(
                    Controller.displayLogoSubTitle,
                    style: CustomTextStyle.subTitle(context),
                  ),
                ],
              )),
          width: ScreenUtil.getInstance().setWidth(750),
          height: ScreenUtil.getInstance().setHeight(190),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(60),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    onPressed: () =>
                        setState(() => Controller.changeToSignIn()),
                    borderSide: new BorderSide(
                      style: BorderStyle.none,
                    ),
                    child: new Text(Controller.displaySignInMenuButton,
                        style: _signInActive
                            ? TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold)
                            : TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.normal)),
                  ),
                  OutlineButton(
                    onPressed: () =>
                        setState(() => Controller.changeToSignUp()),
                    borderSide: BorderSide(
                      style: BorderStyle.none,
                    ),
                    child: Text(Controller.displaySignUpMenuButton,
                        style: _signUpActive
                            ? TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold)
                            : TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.normal)),
                  )
                ],
              ),
            ),
          ),
          width: ScreenUtil.getInstance().setWidth(750),
          height: ScreenUtil.getInstance().setHeight(170),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(10),
        ),
        Container(
          child: Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: _signInActive ? _showSignIn(context) : _showSignUp()),
          width: ScreenUtil.getInstance().setWidth(750),
          height: ScreenUtil.getInstance().setHeight(778),
        ),
      ],
    );
  }

  Widget _showSignIn(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(30),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              style: TextStyle(color: Theme.of(context).accentColor),
              controller: _emailController,
              decoration: InputDecoration(
                hintText: Controller.displayHintTextEmail,
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                prefixIcon: Icon(
                  Icons.email,
                  color: Theme.of(context).accentColor,
                ),
              ),
              obscureText: false,
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(50),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: true,
              style: TextStyle(color: Theme.of(context).accentColor),
              controller: _passwordController,
              decoration: InputDecoration(
                //Add th Hint text here.
                hintText: Controller.displayHintTextPassword,
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                prefixIcon:
                Icon(Icons.lock, color: Theme.of(context).accentColor),
              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(80),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: RaisedButton(
              child: Row(
                children: <Widget>[
                  SocialIcon(iconData: CustomIcons.facebook),
                  Expanded(
                    child: Text(
                      Controller.displaySignInAuth0Button,
                      textAlign: TextAlign.center,
                      style: CustomTextStyle.button(context),
                    ),
                  )
                ],
              ),
              color: Theme.of(context).buttonColor,
              onPressed: () => Controller.tryToLogInUserViaAuth(
                  this.auth, _emailController, _passwordController),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(30),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                horizontalLine(),
                Text(Controller.displaySeparatorText,
                    style: CustomTextStyle.body(context)),
                horizontalLine()
              ],
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(30),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: RaisedButton(
              child: Row(
                children: <Widget>[
                  SocialIcon(iconData: CustomIcons.facebook),
                  Expanded(
                    child: Text(
                      Controller.displaySignInAuth0Button,
                      textAlign: TextAlign.center,
                      style: CustomTextStyle.button(context),
                    ),
                  )
                ],
              ),
              color: Theme.of(context).buttonColor,
              onPressed: () => Controller.tryToLogInUserViaAuth(
                  this.auth, _emailController, _passwordController),
            ),
          ),
        ),
        Container(
          child: Padding(
              padding: EdgeInsets.only(),
              child: RaisedButton(
                child: Row(
                  children: <Widget>[
                    SocialIcon(iconData: CustomIcons.facebook),
                    Expanded(
                      child: Text(
                        Controller.displaySignInFacebookButton,
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.button(context),
                      ),
                    )
                  ],
                ),
                color: Color(0xFF3C5A99),
                onPressed: () async {
                  setState(() {
                    visible = true;
                  });
                  Controller.tryToLogInUserViaFacebook(this.auth, context);
                },
              )),
        ),
        Visibility(
            visible: visible,
            child: Container(
                margin: EdgeInsets.only(bottom: 30),
                child: CircularProgressIndicator())),
      ],
    );
  }

  Widget _showSignUp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(30),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: false,
              style: CustomTextStyle.formField(context),
              controller: _newEmailController,
              decoration: InputDecoration(
                //Add th Hint text here.
                hintText: Controller.displayHintTextNewEmail,
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                prefixIcon: Icon(
                  Icons.email,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(50),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: true,
              style: CustomTextStyle.formField(context),
              controller: _newPasswordController,
              decoration: InputDecoration(
                //Add the Hint text here.
                hintText: Controller.displayHintTextNewPassword,
                hintStyle: CustomTextStyle.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1.0)),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil.getInstance().setHeight(80),
        )
      ],
    );
  }

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtil.getInstance().setWidth(120),
      height: 1.0,
      color: Theme.of(context).accentColor,
    ),
  );

  Widget emailErrorText() => Text(Controller.displayErrorEmailLogIn);
}

class LogInPage extends StatefulWidget {
  LogInPage({Key key}) : super(key: key);

  @protected
  @override
  State<StatefulWidget> createState() => _LogInPageState();
}

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

  static void changeToSignUp() => Model._changeToSignUp();

  static void changeToSignIn() => Model._changeToSignIn();

  static Future<Post> signInWithAuth(Auth0 auth, email, password) =>
      Model._signInWithAuth(auth, email, password);

  static Future<Post> signInWithFacebook(Auth0 auth, context) =>
      Model._signInWithFacebook(auth, context);

  static Future navigateToProfile(post) =>
      Model._navigateToProfile(post);

  static Future tryToLogInUserViaAuth(
      Auth0 auth, email, password) async {
    Post post = await signInWithAuth(auth, email, password);
    if (post != null) {
      navigateToProfile(post);
    }
  }

  static Future tryToLogInUserViaFacebook(Auth0 auth, context) async {
    Post post = await signInWithFacebook(auth, context);
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
}

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
    await _navigationService.navigateTo(HomeViewRoute);
  }
}
