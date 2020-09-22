import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tutorappnew/screens/FirstScreens/covid19assessment.dart';
import 'package:tutorappnew/services/auth.dart';

class TeacherPendingRequest extends StatefulWidget {
  String uid;
  String name;
  String imageUrl;
  TeacherPendingRequest({this.uid, this.imageUrl, this.name});
  @override
  _TeacherPendingRequestState createState() => _TeacherPendingRequestState();
}

class _TeacherPendingRequestState extends State<TeacherPendingRequest> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              AuthService authService = AuthService();
              await authService.signOut();
            },
            label: Text("Logout"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                FadeInLeft(
                  delay: Duration(milliseconds: 1000),
                  child: Text(
                    "Welcome",
                    style: TextStyle(fontFamily: "Cocogoose", fontSize: 20),
                  ),
                ),
                FadeInUp(
                    child: Container(
                  width: 20,
                  height: 2,
                  color: Colors.teal,
                )),
                FadeInUp(
                  child: Text(
                    widget.name,
                    style: TextStyle(fontFamily: "Roboto", fontSize: 20),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 20, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal),
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        children: [
                          widget.imageUrl == null
                              ? Image.asset(
                                  'assets/profile.png',
                                  height: 30,
                                  width: 30,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    widget.imageUrl,
                                  ),
                                ),
                          Text(
                            "The request to create your account " +
                                "has been send to the team, the team will review and approve if you are valid.",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 10, top: 20, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Welcome to the COVID-19 self-assessment tool",
                        style: TextStyle(color: Colors.red),
                      ),
                      Image.asset(
                        'assets/doctor.png',
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        "Please give correct answers",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Accurate answers help us - help you better. To make your account review faster take self assessment.",
                        textAlign: TextAlign.center,
                      ),
                      OutlineButton(
                        splashColor: Colors.tealAccent,
                        borderSide: BorderSide(color: Colors.teal),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Covid19Assessment(widget.uid),
                          ));
                        },
                        child: Text(
                          "Assess yourself",
                          style: TextStyle(color: Colors.teal),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
