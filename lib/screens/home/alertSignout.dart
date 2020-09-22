import 'package:tutorappnew/screens/wrapper.dart';
import 'package:tutorappnew/services/auth.dart';
import 'package:flutter/material.dart';

class AlertSignOut extends StatefulWidget {
  @override
  _AlertSignOutState createState() => _AlertSignOutState();
}

class _AlertSignOutState extends State<AlertSignOut> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you Sure?'),
      actions: [
        RaisedButton(
          onPressed: () {
            AuthService().signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Wrapper()));
          },
          child: Text('Yes'),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('No'),
        ),
      ],
    );
  }
}
