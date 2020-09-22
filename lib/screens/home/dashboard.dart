import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tutorappnew/loading.dart';
import 'package:tutorappnew/models/subject.dart';
import 'package:tutorappnew/models/user.dart';
import 'package:tutorappnew/screens/home/category.dart';
import 'package:tutorappnew/screens/home/dashboard/Parentdashboard.dart';
import 'package:tutorappnew/screens/home/sidedrawer/studentInfo.dart';
import 'package:tutorappnew/screens/home/sidedrawer/teacherinfo.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  final UserType data;
  DashBoard({this.data});
  @override
  _DashBoardState createState() => _DashBoardState(data: data);
}

class _DashBoardState extends State<DashBoard> {
  final UserType data;
  AnimationController animateController;
  _DashBoardState({this.data});

  List<String> categories = ['Arts', 'Science', 'Social Science', 'Others'];
  List<String> categoryImage = [
    'assets/paint.png',
    'assets/physics.png',
    'assets/earth.png',
    'assets/video-call.png'
  ];

  @override
  Widget build(BuildContext context) {
    return data.typeOfUser == "Student"
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<QuerySnapshot>(
                future: Firestore.instance
                    .collection('Users')
                    .where('userType', isEqualTo: "Teacher")
                    .limit(20)
                    .getDocuments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      child: SpinKitCircle(
                          duration: Duration(seconds: 1), color: Colors.teal),
                    );
                  }
                  if (snapshot.hasError) {
                    return Container(
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      child: SpinKitCircle(
                          duration: Duration(seconds: 1), color: Colors.teal),
                    );
                  }
                  List<DocumentSnapshot> documents = [];
                  snapshot.data.documents.forEach((element) {
                    if (element.data['approved'] == 1 &&
                        element.data['rating'] >= 3) {
                      documents.add(element);
                    }
                  });
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Popular Tutors",
                              style: TextStyle(
                                  fontFamily: "Cocogoose", fontSize: 20),
                            ),
                          ),
                          Spin(
                            manualTrigger: true,
                            controller: (controller) =>
                                animateController = controller,
                            child: IconButton(
                                icon: Icon(FontAwesomeIcons.sync),
                                onPressed: () {
                                  animateController.reverse();
                                  Timer(Duration(seconds: 1), () {
                                    animateController.forward().then((value) {
                                      setState(() {});
                                    });
                                  });
                                }),
                          )
                        ],
                      ),
                      Container(
                        height: 220,
                        child: ListView.builder(
                          itemCount: documents.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Teacher teacher = new Teacher(
                                  enrolledStudents: documents[index]
                                      ['enrolledStudents'],
                                  point: documents[index]['location']
                                      ['geopoint'],
                                  name: documents[index]['name'],
                                  description: documents[index]['description'],
                                  photo: documents[index]['photo'],
                                  age: documents[index]['age'],
                                  exp: documents[index]['exp'],
                                  email: documents[index]['emailid'],
                                  phoneno: documents[index]['phoneno'],
                                  subjects: documents[index]['subjects'],
                                  url: documents[index]['url'],
                                  charge: documents[index]['charge'],
                                  uid: documents[index].documentID,
                                  curricullum: documents[index]['curricullum'],
                                  curricullumPdf: documents[index]
                                      ['curricullumPdf']);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TeacherInfo(
                                  studentUid: widget.data.uid,
                                  teacher: teacher,
                                ),
                              ));
                            },
                            child: FadeIn(
                              child: Container(
                                height: 130,
                                child: Stack(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            documents[index]['url'],
                                            width: 130,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child:
                                                Text(documents[index]['name']),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                              documents[index]['subjects'],
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 6),
                                            child: RatingBar(
                                              ignoreGestures: true,
                                              initialRating: double.parse(
                                                  documents[index]['rating']
                                                      .toString()),
                                              itemSize: 20,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    documents[index]['enrolledStudents']
                                            .contains(data.uid)
                                        ? Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, bottom: 6),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .moneyBill,
                                                      size: 10,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Purchased",
                                                    style: TextStyle(
                                                        color: Colors.teal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Text("")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Categories",
                  style: TextStyle(fontFamily: "Cocogoose", fontSize: 20),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 2.0,
                      child: Container(
                        height: 200,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: SweepGradient(
                                colors: [Colors.teal, Colors.greenAccent])),
                        child: InkWell(
                          splashColor: Colors.teal[100],
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  Category(categories[index], data),
                            ));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                categoryImage[index],
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                categories[index],
                                style: TextStyle(fontFamily: "Cocogoose"),
                              )
                            ],
                          ),
                        ),
                      )),
                  itemCount: 4,
                ),
              )
            ],
          )
        : data.typeOfUser == 'Teacher'
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Enrolled Students",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Cocogoose",
                              fontSize: 18)),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: FutureBuilder<DocumentSnapshot>(
                        future: Firestore.instance
                            .collection('Users')
                            .document(widget.data.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: SpinKitCircle(
                                  duration: Duration(seconds: 1),
                                  color: Colors.teal),
                            );
                          }
                          if (snapshot.hasError) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: SpinKitCircle(
                                  duration: Duration(seconds: 1),
                                  color: Colors.teal),
                            );
                          }
                          print(snapshot.data['enrolledStudents'].length);
                          return ListView.builder(
                            physics: ScrollPhysics(),
                            itemCount: snapshot.data['enrolledStudents'].length,
                            itemBuilder: (context, index) {
                              if (!snapshot.hasData) {
                                return SpinKitCircle(
                                    duration: Duration(seconds: 1),
                                    color: Colors.teal);
                              }
                              if (snapshot.hasError) {
                                return SpinKitCircle(
                                    duration: Duration(seconds: 1),
                                    color: Colors.teal);
                              }
                              return FutureBuilder(
                                  future: Firestore.instance
                                      .collection('Users')
                                      .document(snapshot
                                          .data['enrolledStudents'][index])
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return SpinKitCircle(
                                          duration: Duration(seconds: 1),
                                          color: Colors.teal);
                                    }
                                    if (snapshot.hasError) {
                                      return SpinKitCircle(
                                          duration: Duration(seconds: 1),
                                          color: Colors.teal);
                                    }
                                    return ListTile(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => StudentInfo(
                                            imageUrl: snapshot.data['url'],
                                            name: snapshot.data['name'],
                                            emailid: snapshot.data['emailid'],
                                            location: snapshot.data['location']
                                                ['geopoint'],
                                            phoneno: snapshot.data['phoneno'],
                                          ),
                                        ));
                                      },
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(snapshot.data['url']),
                                      ),
                                      title: Text(snapshot.data['name']),
                                      subtitle: Text(snapshot.data['emailid']),
                                    );
                                  });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : data.typeOfUser == 'Parent'
                ? ParentDashBoard(uid: data.uid)
                : Loading();
  }
}
