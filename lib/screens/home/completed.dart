import 'package:flutter/material.dart';
import 'package:tutorappnew/loading.dart';

class Completed extends StatefulWidget {
  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed'),
        backgroundColor: Colors.white,
      ),
    );
  }
}
