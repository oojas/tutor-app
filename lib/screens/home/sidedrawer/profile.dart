import 'package:tutorappnew/screens/home/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  String url;
  String uid;
  ProfilePage({this.url, this.uid});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Edit Profile'),
      ),
      body: Builder(
        builder: (context) => EditProfile(
          uid: widget.uid,
        ),
      ),
    );
  }
}
