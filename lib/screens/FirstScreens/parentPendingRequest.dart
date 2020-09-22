import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tutorappnew/services/auth.dart';

class ParentPendingRequest extends StatefulWidget {
  String uid;
  ParentPendingRequest({this.uid});
  @override
  _ParentPendingRequestState createState() => _ParentPendingRequestState();
}

class _ParentPendingRequestState extends State<ParentPendingRequest> {
  int approved = 0;
  @override
  void initState() {
    super.initState();
  }

  getData() async {
    Firestore.instance
        .collection('Users')
        .document(widget.uid)
        .get()
        .then((value) {
      setState(() {
        approved = value['approved'];
      });
    });
  }

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
          body: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              FadeInDown(
                child: Center(
                  child: Image.asset('assets/parents.png'),
                ),
              ),
              FadeInDown(
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
                ),
              ),
              FadeInUp(
                child: Text(
                  'name',
                  style: TextStyle(fontFamily: "Roboto", fontSize: 20),
                ),
              ),
              FadeInUp(
                child: Container(
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
                          Text(
                            "The request to approve your account " +
                                "has been send to the team, the team will review and approve your account.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
