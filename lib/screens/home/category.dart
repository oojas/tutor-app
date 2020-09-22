import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutorappnew/models/subject.dart';
import 'package:tutorappnew/models/user.dart';
import 'package:tutorappnew/screens/home/sidedrawer/teacherinfo.dart';

class Category extends StatefulWidget {
  String category;
  UserType data;
  Category(this.category, this.data);
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.category),
        elevation: 0.0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Users')
            .where('userType', isEqualTo: "Teacher")
            .where(
              'approved',
              isEqualTo: 1,
            )
            .where('category', isEqualTo: widget.category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SpinKitCircle(
              duration: Duration(seconds: 1),
              size: 20,
              color: Colors.teal,
            );
          }
          if (!snapshot.hasData) {
            return SpinKitCircle(
              duration: Duration(seconds: 1),
              size: 20,
              color: Colors.teal,
            );
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) => Card(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Teacher teacher = new Teacher(
                                enrolledStudents: snapshot.data.documents[index]
                                    ['enrolledStudents'],
                                point: snapshot.data.documents[index]
                                    ['location']['geopoint'],
                                name: snapshot.data.documents[index]['name'],
                                description: snapshot.data.documents[index]
                                    ['description'],
                                photo: snapshot.data.documents[index]['photo'],
                                age: snapshot.data.documents[index]['age'],
                                exp: snapshot.data.documents[index]['exp'],
                                email: snapshot.data.documents[index]
                                    ['emailid'],
                                phoneno: snapshot.data.documents[index]
                                    ['phoneno'],
                                subjects: snapshot.data.documents[index]
                                    ['subjects'],
                                url: snapshot.data.documents[index]['url'],
                                charge: snapshot.data.documents[index]
                                    ['charge'],
                                uid: snapshot.data.documents[index].documentID,
                                curricullum: snapshot.data.documents[index]
                                    ['curricullum'],
                                curricullumPdf: snapshot.data.documents[index]
                                    ['curricullumPdf']);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TeacherInfo(
                                studentUid: widget.data.uid,
                                teacher: teacher,
                              ),
                            ));
                          },
                          child: Image.network(
                              snapshot.data.documents[index]['url'],
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill),
                        ),
                        snapshot.data.documents[index]['enrolledStudents']
                                .contains(widget.data.uid)
                            ? Align(
                                child: Container(
                                    color: Colors.white.withOpacity(0.5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Already Purchased",
                                        style: TextStyle(
                                            color: Colors.teal,
                                            fontFamily: "Cocogoose"),
                                      ),
                                    )),
                                alignment: Alignment.center,
                              )
                            : Container(),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white.withOpacity(0.5),
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: Row(
                                      children: [
                                        AvatarGlow(
                                            showTwoGlows: true,
                                            glowColor: Colors.blue,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.red,
                                              radius: 5,
                                            ),
                                            endRadius: 10),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.26,
                                          child: Text(
                                            snapshot.data.documents[index]
                                                ['name'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.33,
                                    child: Row(
                                      children: [
                                        AvatarGlow(
                                            glowColor: Colors.blue,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.red,
                                              radius: 5,
                                            ),
                                            endRadius: 10),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.26,
                                          child: Text(
                                            snapshot.data.documents[index]
                                                ['subjects'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: Row(
                                      children: [
                                        AvatarGlow(
                                            glowColor: Colors.blue,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.red,
                                              radius: 5,
                                            ),
                                            endRadius: 10),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.26,
                                          child: RatingBar(
                                            ignoreGestures: true,
                                            initialRating: double.parse(snapshot
                                                .data.documents[index]['rating']
                                                .toString()),
                                            itemSize: 15,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.teal,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    )),
              ),
            ),
          );
        },
      ),
    );
  }
}
