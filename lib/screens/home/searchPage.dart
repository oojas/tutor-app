import 'dart:async';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tutorappnew/screens/home/sidedrawer/teacherinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tutorappnew/models/subject.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:tutorappnew/screens/payment/PayStack.dart';

class SearchPage extends SearchDelegate {
  String studentUid;
  LatLng studentCordinates;

  SearchPage({this.studentCordinates, this.studentUid});
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Marker studentMarker;
  Completer<GoogleMapController> _controller = Completer();
  List<Subject> subjects = [
    Subject(name: "Mathematics", imagePath: 'assets/math.png'),
    Subject(name: "English", imagePath: 'assets/english.png'),
    Subject(name: "C++", imagePath: 'assets/c++.png'),
  ];
  List<Teacher> teacher = [];
  List<Teacher> newteachers = [];
  final geo = Geoflutterfire();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    CameraPosition cameraPosition;

    cameraPosition = CameraPosition(target: studentCordinates, zoom: 15);
    return query != ""
        ? FutureBuilder<List<Teacher>>(
            future: getList(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: SpinKitCircle(
                  color: Colors.teal,
                  duration: Duration(seconds: 1),
                ));
              }
              if (snapshot.hasError) {
                return Center(
                    child: SpinKitCircle(
                  color: Colors.teal,
                  duration: Duration(seconds: 1),
                ));
              }

              //teacher = snapshot.data.documents.map(buildTeacherList).toList();
              int delay = 200;
              return snapshot.data.length > 0
                  ? SingleChildScrollView(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                teacher.length.toString() +
                                    " tutor teach " +
                                    query +
                                    ' near you.',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"),
                              ),
                            ),
                            ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: teacher.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => TeacherInfo(
                                            teacher: teacher[index],
                                            studentUid: studentUid,
                                          ),
                                        ),
                                      );
                                    },
                                    child: FadeInUp(
                                      child: Stack(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child:
                                                                Image.network(
                                                              teacher[index]
                                                                  .url,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              height: 350,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: Container(
                                                            height: 20,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.1),
                                                            child: Text(
                                                              teacher[index]
                                                                  .name,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 2.0),
                                                child: Row(
                                                  children: [
                                                    OutlineButton(
                                                      borderSide: BorderSide(
                                                          color: Colors.teal),
                                                      textColor: Colors.teal,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          500)),
                                                      onPressed: () {},
                                                      child: Text("\$" +
                                                          teacher[index]
                                                              .charge +
                                                          " per hour"),
                                                    ),
                                                    Card(
                                                      color: Colors.tealAccent,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          500)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          teacher[index].exp +
                                                              " Yr. Exp",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          teacher[index]
                                                  .enrolledStudents
                                                  .contains(studentUid)
                                              ? Positioned(
                                                  top: 120,
                                                  left: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 -
                                                      100,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            "Already Purchased",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.teal,
                                                                fontFamily:
                                                                    "Cocogoose",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20)),
                                                      )))
                                              : Container()
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Container(child: Text("No Data Found..")),
                    );
            },
          )
        : Container();
  }

  Future<List<Teacher>> getList(BuildContext context) async {
    teacher = [];
    QuerySnapshot querySnapshots = await Firestore.instance
        .collection("Users")
        .where('userType', isEqualTo: 'Teacher')
        .where('subjects', isEqualTo: query)
        .where('approved', isEqualTo: 1)
        .getDocuments();
    querySnapshots.documents.forEach((element) async {
      double distance = await Geolocator().distanceBetween(
          studentCordinates.latitude,
          studentCordinates.longitude,
          element['location']['geopoint'].latitude,
          element['location']['geopoint'].longitude);
      print(distance);
      if (distance < 100000) {
        teacher.add(buildTeacherList(element));
      }
    });
    return Future.delayed(Duration(seconds: 6), () {
      return teacher;
    });
  }

  Teacher buildTeacherList(DocumentSnapshot documentSnapshot) {
    print(documentSnapshot['location']['geopoint']);
    return Teacher(
        name: documentSnapshot['name'],
        description: documentSnapshot['description'],
        age: documentSnapshot['age'],
        email: documentSnapshot['emailid'],
        exp: documentSnapshot['exp'],
        phoneno: documentSnapshot['phoneno'],
        photo: documentSnapshot['photo'],
        subjects: documentSnapshot['subjects'],
        uid: documentSnapshot.documentID,
        url: documentSnapshot['url'],
        curricullumPdf: documentSnapshot['curricullumPdf'],
        curricullum: documentSnapshot['curricullum'],
        point: documentSnapshot['location']['geopoint'],
        enrolledStudents: documentSnapshot['enrolledStudents'],
        charge: documentSnapshot['charge']);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Subject> suggestions = [];
    subjects.forEach((element) {
      if (element.name.toLowerCase().startsWith(query.toLowerCase())) {
        suggestions.add(element);
      }
    });
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
          onTap: () {
            query = suggestions[index].name;
          },
          leading: Image.asset(
            suggestions[index].imagePath,
            width: 30,
            height: 30,
            color: Colors.teal,
          ),
          title: RichText(
            text: TextSpan(
                text: suggestions[index].name.substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: suggestions[index].name.substring(query.length),
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal))
                ]),
          )),
      itemCount: suggestions.length,
    );
  }

  // Future<QuerySnapshot> getMarkers(BuildContext context) async {
  //   markers.clear();
  //   BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(devicePixelRatio: 2.5),
  //       'assets/currentPosition.png');
  //   studentMarker = Marker(
  //     icon: bitmapDescriptor,
  //     markerId: MarkerId(studentUid),
  //     position: studentCordinates,
  //     infoWindow: InfoWindow(
  //       title: "Student Position",
  //     ),
  //   );
  //   markers[MarkerId(studentUid)] = studentMarker;
  //   return Firestore.instance
  //       .collection("Subjects")
  //       .document(query.toLowerCase())
  //       .collection(query.toLowerCase())
  //       .getDocuments();
  // }

  void showBottomSheet1(BuildContext context, AsyncSnapshot snapshot) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  Navigator.of(context).pop();
                  final GoogleMapController controller =
                      await _controller.future;
                  controller.animateCamera(CameraUpdate.newCameraPosition(
                      new CameraPosition(
                          zoom: 16,
                          target: LatLng(
                              snapshot
                                  .data.documents[index]['coordinate'].latitude,
                              snapshot.data.documents[index]['coordinate']
                                  .longitude))));
                },
                title: Text(query),
                subtitle: Text(snapshot
                        .data.documents[index]['coordinate'].latitude
                        .toString() +
                    " " +
                    snapshot.data.documents[index]['coordinate'].longitude
                        .toString()),
              );
            },
            itemCount: snapshot.data.documents.length,
          ),
        );
      },
    );
  }
}
