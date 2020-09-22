import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutorappnew/loading.dart';
import 'package:tutorappnew/screens/FirstScreens/ParentIntro.dart';
import 'package:tutorappnew/screens/FirstScreens/parentPendingRequest.dart';
import 'package:tutorappnew/screens/FirstScreens/studentIntro.dart';
import 'package:tutorappnew/screens/FirstScreens/teacherIntro.dart';
import 'package:tutorappnew/screens/FirstScreens/teacherPendingRequest.dart';
import 'package:tutorappnew/screens/home/dashboard/Parentdashboard.dart';
import 'package:tutorappnew/screens/home/home.dart';
import 'package:tutorappnew/services/database.dart';
import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Splash extends StatefulWidget {
  String uid;
  Splash({this.uid});
  Widget loadscr;
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  bool seen = false, teacher = false, stu = false, parent = false;
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    setState(() {
      seen = _seen;
    });

    if (_seen) {
      String user = prefs.getString('userType');
      if (user == 'Teacher') {
        setState(() {
          teacher = true;
        });
      }
      if (user == 'Student') {
        setState(() {
          stu = true;
        });
      }
      if (user == 'Parent') {
        setState(() {
          parent = true;
        });
      }
    } else {
      String user = prefs.getString('userType');
      if (user == 'Teacher') {
        setState(() {
          teacher = true;
        });
      }
      if (user == 'Student') {
        setState(() {
          stu = true;
        });
      }
      if (user == 'Parent') {
        setState(() {
          parent = true;
        });
      }
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    print(teacher);
    return seen
        ? teacher
            ? FutureBuilder<DocumentSnapshot>(
                future: Firestore.instance
                    .collection("Users")
                    .document(widget.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: SpinKitCircle(
                        duration: Duration(seconds: 1),
                        color: Colors.teal,
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: SpinKitCircle(
                        duration: Duration(seconds: 1),
                        color: Colors.teal,
                      ),
                    );
                  }
                  if (snapshot.data['approved'] == 0) {
                    return TeacherPendingRequest(
                      uid: widget.uid,
                      imageUrl: snapshot.data['url'],
                      name: snapshot.data['name'],
                    );
                  }
                  return Home();
                })
            : parent
                ? FutureBuilder<DocumentSnapshot>(
                    future: Firestore.instance
                        .collection("Users")
                        .document(widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: SpinKitCircle(
                            duration: Duration(seconds: 1),
                            color: Colors.teal,
                          ),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: SpinKitCircle(
                            duration: Duration(seconds: 1),
                            color: Colors.teal,
                          ),
                        );
                      }
                      if (snapshot.data['approved'] == 0) {
                        return ParentPendingRequest(
                          uid: widget.uid,
                        );
                      }
                      return Home();
                    })
                : Loading()
        : teacher
            ? TeacherIntro(
                uid: widget.uid,
              )
            : stu
                ? StudentIntro(
                    uid: widget.uid,
                  )
                : parent
                    ? ParentIntro(
                        uid: widget.uid,
                      )
                    : Loading();
  }
}
