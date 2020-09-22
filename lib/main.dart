import 'package:tutorappnew/services/auth.dart';
import 'package:tutorappnew/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Onboarding',
        theme: ThemeData(
            fontFamily: "Roboto",
            primaryColor: Colors.white,
            accentColor: Colors.teal,
            iconTheme: IconThemeData(color: Colors.teal),
            primaryIconTheme: IconThemeData(color: Colors.teal),
            scaffoldBackgroundColor: Color(0XFFEFF3F6)),
        home: Wrapper(),
      ),
    );
  }
}
