import 'package:flutter/material.dart';
import 'package:flutter_app/Objects/user.dart';
import 'package:flutter_app/Screens/preference_page.dart';
import 'package:flutter_app/main.dart';

class Profile extends StatelessWidget {
  final User user = User();
  final Post post;

  Profile({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                  Text("Name: " + user.name.toString()),
                  Text("Email: " + post.email.toString()),
                  Text("Facebook ID: " + user.fbID.toString()),
                  Text("Picture url: "+ user.url.toString()),
                  Text("Post title: "+ post.title.toString()),
                  Text("Post token: "+ post.token.toString()),
                ],
              )
              //child: _displayUserData(user.profileData),
            ),
        ),
      ),
    );
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
