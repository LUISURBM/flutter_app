import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/auth/bloc/authentication_bloc.dart';
import 'package:flutter_app/auth/login/bloc/login_bloc.dart';
import 'package:flutter_app/model.dart';
import 'package:flutter_app/model/post.dart';
import 'package:flutter_app/ui/cutom_styles.dart';
import 'package:flutter_app/viewmodels/login_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/CustomIcons.dart';
import 'package:flutter_app/Widgets/SocialIcons.dart';
import 'package:flutter_app/auth0.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

var facebookLogin = FacebookLogin();
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _newEmailController = TextEditingController();
TextEditingController _newPasswordController = TextEditingController();

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

class _LogInPageState extends StateMVC<LogInPage> {
  _LogInPageState() : super(Controller());

  // For CircularProgressIndicator.
  bool visible = false;
  // For Log process.
  bool logIn = false;

  @override
  void initState() {}

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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocProvider(
            builder: (context) => LoginBloc(authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
            child: BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginFailure) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${state.error}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: BlocBuilder<LoginBloc, LoginState>(
                    builder: _buildWithLogin))));
  }

  Widget _buildWithLogin(BuildContext context, LoginState state) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: BlocProvider<LoginBloc>(
            builder: (context) => LoginBloc()..dispatch(LoginStarted()),
            child: Column(
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
                  height: ScreenUtil.getInstance().setHeight(230),
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
                            onPressed: () => setState(() => logIn = true),
                            borderSide: new BorderSide(
                              style: BorderStyle.none,
                            ),
                            child: new Text(Controller.displaySignInMenuButton,
                                style: logIn
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
                            onPressed: () => setState(() => logIn = false),
                            borderSide: BorderSide(
                              style: BorderStyle.none,
                            ),
                            child: Text(Controller.displaySignUpMenuButton,
                                style: !logIn
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
                      child: logIn ? _showSignIn(context) : _showSignUp()),
                  width: ScreenUtil.getInstance().setWidth(750),
                  height: ScreenUtil.getInstance().setHeight(778),
                ),
              ],
            )));
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
              color: Theme.of(context).accentColor,
              onPressed: () => BlocProvider.of<LoginBloc>(context).dispatch(
                LoginButtonPressed(
                  username: _emailController.text,
                  password: _passwordController.text,
                ),
              ),
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
                  Controller.tryToLogInUserViaFacebook(context);
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
