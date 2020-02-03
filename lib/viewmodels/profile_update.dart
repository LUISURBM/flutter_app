import 'dart:convert';
import 'package:flutter_app/viewmodels/login_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/Objects/user.dart';
import 'package:flutter_app/ui/views/preference_page.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../auth/login/ui/login_page.dart';

class Profile extends StatelessWidget {
  final User user = User();
  final Post post;

  Profile({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginViewModel>.withConsumer(
    viewModel: LoginViewModel(),
    builder: (context, model, child) => MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .accentColor,
          title: Text("Profile :"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Navigate to the PreferencePage
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PreferencePage(),
                ));
              },
            )
          ],
        ),
        body: Container(
          child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Name: " + user.name),
                  Text("Email: " + post.email),
                  Text("Facebook ID: " + user.fbID),
                  Text("Picture url: "+ user.url),
                  Text("Post title: "+ post.title),
                  Text("Post token: "+ post.token),
                ],
              )
              //child: _displayUserData(user.profileData),
            ),
        ),
      ),
    ));
  }

  /** _displayUserData(profileData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
               image: NetworkImage(
                profileData['picture']['data']['url'],
              ),
              
            ),
          ),
        ),
        SizedBox(height: 28.0),
        Text(
          "Logged in as: ${profileData['name']}",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ],
    );
}*/

}

class LoginUser extends StatefulWidget {
  LoginUserState createState() => LoginUserState();
}

class LoginUserState extends State {
  // For CircularProgressIndicator.
  bool visible = false;

  // Getting value from TextField widget.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future userLogin() async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String email = emailController.text;
    String password = passwordController.text;

    // SERVER LOGIN API URL
    var url = 'https://flutter-examples.000webhostapp.com/login_user.php';

    // Store all data with Param Name.
    var data = {'email': email, 'password': password};

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);

    // If the Response Message is Matched.
    if (message == 'Login Matched') {
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProfileScreen(email: emailController.text)));
    } else {
      // If Email or Password did not Matched.
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(message),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('User Login Form', style: TextStyle(fontSize: 21))),
                  Divider(),
                  Container(
                      width: 280,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: emailController,
                        autocorrect: true,
                        decoration: InputDecoration(hintText: 'Enter Your Email Here'),
                      )),
                  Container(
                      width: 280,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: passwordController,
                        autocorrect: true,
                        obscureText: true,
                        decoration:
                        InputDecoration(hintText: 'Enter Your Password Here'),
                      )),
                  RaisedButton(
                    onPressed: userLogin,
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                    child: Text('Click Here To Login'),
                  ),
                  Visibility(
                      visible: visible,
                      child: Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: CircularProgressIndicator())),
                ],
              ),
            )));
  }
}

class ProfileScreen extends StatelessWidget {
// Creating String Var to Hold sent Email.
  final String email;

// Receiving Email using Constructor.
  ProfileScreen({Key key, @required this.email}) : super(key: key);

// User Logout Function.
  logout(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: Text('Profile Screen'),
                automaticallyImplyLeading: false),
            body: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 280,
                        padding: EdgeInsets.all(10.0),
                        child: Text('Email = ' + '\n' + email,
                            style: TextStyle(fontSize: 20))),
                    RaisedButton(
                      onPressed: () {
                        logout(context);
                      },
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text('Click Here To Logout'),
                    ),
                  ],
                ))));
  }
}
