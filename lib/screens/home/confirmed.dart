import 'package:tutorappnew/loading.dart';
import 'package:tutorappnew/models/user.dart';
import 'package:flutter/material.dart';

class Confirmed extends StatefulWidget {
  final UserType data;
  Confirmed({this.data});
  @override
  _ConfirmedState createState() => _ConfirmedState(data: data);
}

class _ConfirmedState extends State<Confirmed> {
  final UserType data;
  _ConfirmedState({this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmed'),
        backgroundColor: Colors.white,
      ),
    );
  }
}
