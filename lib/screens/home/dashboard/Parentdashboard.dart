import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutorappnew/loading.dart';
import 'package:tutorappnew/models/subject.dart';
import 'package:tutorappnew/models/user.dart';

class ParentDashBoard extends StatefulWidget {
  String uid;
  ParentDashBoard({this.uid});
  @override
  _ParentDashBoardState createState() => _ParentDashBoardState();
}

class _ParentDashBoardState extends State<ParentDashBoard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration mbox = BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            offset: Offset(2, 2),
            blurRadius: 2,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 5,
          ),
        ]);
    return FutureBuilder<DocumentSnapshot>(
      future: Firestore.instance.collection('Users').document(widget.uid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SpinKitCircle(
            color: Colors.teal,
            duration: Duration(seconds: 1),
          );
        }
        if (snapshot.hasError) {
          return SpinKitCircle(
            color: Colors.teal,
            duration: Duration(seconds: 1),
          );
        }
        return FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection('coursesPurchased')
              .document(snapshot.data['child'])
              .collection('coursesPurchased')
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SpinKitCircle(
                color: Colors.teal,
                duration: Duration(seconds: 1),
              );
            }
            if (snapshot.hasError) {
              return SpinKitCircle(
                color: Colors.teal,
                duration: Duration(seconds: 1),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
                  child: Text(
                    "Your child have " +
                        snapshot.data.documents.length.toString() +
                        " classes to attend",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: FadeInUp(
                          child: Container(
                            decoration: mbox,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                title: Text(
                                  snapshot.data.documents[index]['name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  snapshot.data.documents[index]['subjects'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      snapshot.data.documents[index]['url']),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
