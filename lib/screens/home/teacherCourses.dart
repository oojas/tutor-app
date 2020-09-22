import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tutorappnew/screens/home/courseDetails.dart';

class CoursesPurchased extends StatefulWidget {
  String userid;
  CoursesPurchased({this.userid});
  @override
  _CoursesPurchasedState createState() => _CoursesPurchasedState();
}

class _CoursesPurchasedState extends State<CoursesPurchased> {
  @override
  Widget build(BuildContext context) {
    print(widget.userid);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Courses"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('coursesPurchased')
            .document(widget.userid)
            .collection('coursesPurchased')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SpinKitCircle(
              duration: Duration(seconds: 1),
              color: Colors.teal,
            );
          }
          if (snapshot.hasError) {
            return SpinKitCircle(
              duration: Duration(seconds: 1),
              color: Colors.teal,
            );
          }
          print(snapshot.data.documents.length);
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              child: OutlineButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CourseDetials(
                      userid: widget.userid,
                      age: snapshot.data.documents[index]['url'],
                      charge: snapshot.data.documents[index]['charge'],
                      description: snapshot.data.documents[index]
                          ['description'],
                      email: snapshot.data.documents[index]['email'],
                      enrolledStudents: snapshot.data.documents[index]
                          ['enrolledStudents'],
                      exp: snapshot.data.documents[index]['exp'],
                      name: snapshot.data.documents[index]['name'],
                      phoneno: snapshot.data.documents[index]['phoneno'],
                      point: snapshot.data.documents[index]['point'],
                      subjects: snapshot.data.documents[index]['subjects'],
                      uid: snapshot.data.documents[index]['uid'],
                      url: snapshot.data.documents[index]['url'],
                    ),
                  ));
                },
                borderSide: BorderSide(color: Colors.teal),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(snapshot.data.documents[index]['url']),
                  ),
                  title: Text(snapshot.data.documents[index]['name']),
                  subtitle: Text(snapshot.data.documents[index]['email'] +
                      "\n" +
                      snapshot.data.documents[index]['subjects']),
                  isThreeLine: true,
                  trailing: Icon(
                    Icons.arrow_right,
                    color: Colors.teal,
                    size: 30,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
