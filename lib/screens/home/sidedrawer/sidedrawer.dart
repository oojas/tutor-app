import 'package:animate_do/animate_do.dart';
import 'package:tutorappnew/models/user.dart';
import 'package:tutorappnew/screens/home/classes.dart';
import 'package:tutorappnew/screens/home/completed.dart';
import 'package:tutorappnew/screens/home/confirmed.dart';
import 'package:tutorappnew/screens/home/coursesPurchased.dart';
import 'package:tutorappnew/screens/home/new.dart';
import 'package:tutorappnew/screens/home/sidedrawer/dash.dart';
import 'package:tutorappnew/screens/home/sidedrawer/profile.dart';
import 'package:tutorappnew/screens/home/termsandconditions.dart';
import 'package:tutorappnew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../privacyPolicy.dart';

// ignore: must_be_immutable
class SideDrawer extends StatelessWidget {
  final UserType data;
  final String url, username;
  SideDrawer({this.data, this.username, this.url});
  TextStyle style = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.grey[600],
  );
  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: ElasticInDown(
              child: Center(
                child: FlatButton(
                  onPressed: () {},
                  clipBehavior: Clip.antiAlias,
                  shape:
                      CircleBorder(side: BorderSide(style: BorderStyle.solid)),
                  child: url == ''
                      ? Icon(FontAwesomeIcons.userCircle)
                      : Image.network(
                          url,
                        ),
                ),
              ),
            ),
            decoration: BoxDecoration(color: Colors.teal),
          ),
          data.typeOfUser == "Student"
              ? Column(
                  children: [
                    ListTile(
                      leading: Icon(FontAwesomeIcons.book),
                      title: Text(
                        'Your Courses',
                        style: style,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CoursesPurchased(userid: data.uid)));
                      },
                    ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.mobileAlt),
                      title: Text(
                        'About us',
                        style: style,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        showAboutDialog(
                          context: context,
                          applicationIcon: Image.asset('assets/teacher.png'),
                          applicationName: "Tutor App",
                          applicationVersion: "1.0.0",
                          applicationLegalese:
                              "About tutor app lorem ipasum oplki lorem ipsum",
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Privacy policy',
                        style: TextStyle(fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PrivacyPolicy(),
                        ));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Terms & Conditions',
                        style: TextStyle(fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TermsandConditions(),
                        ));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Help and assistance',
                        style: TextStyle(fontSize: 15),
                      ),
                      onTap: () {},
                    ),
                  ],
                )
              : Column(
                  children: [
                    ListTile(
                      leading: Icon(FontAwesomeIcons.userCircle),
                      title: Text(
                        'My Profile',
                        style: style,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                      url: data.url,
                                    )));
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Privacy policy',
                        style: TextStyle(fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PrivacyPolicy(),
                        ));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Terms & Conditions',
                        style: TextStyle(fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TermsandConditions(),
                        ));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Help and assistance',
                        style: TextStyle(fontSize: 15),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
