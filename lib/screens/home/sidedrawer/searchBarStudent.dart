import 'package:tutorappnew/screens/home/sidedrawer/teacherinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class SearchonMapforStudent extends StatefulWidget {
  LatLng studentCordinates;
  String searchedContent;
  String studentUid;
  SearchonMapforStudent(
      {this.searchedContent, this.studentCordinates, this.studentUid});
  @override
  _SearchonMapforStudentState createState() => _SearchonMapforStudentState();
}

class _SearchonMapforStudentState extends State<SearchonMapforStudent> {
  CameraPosition cameraPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Marker studentMarker;
  @override
  void initState() {
    super.initState();
    cameraPosition = CameraPosition(target: widget.studentCordinates, zoom: 15);
    studentMarker = Marker(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return TeacherInfo();
          },
        );
      },
      markerId: MarkerId(widget.studentUid),
      position: widget.studentCordinates,
      infoWindow: InfoWindow(
        title: "Student Positio",
      ),
    );
    markers[MarkerId(widget.studentUid)] = studentMarker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Searched Subject"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("Subjects")
            .document(widget.searchedContent.toLowerCase())
            .collection(widget.searchedContent.toLowerCase())
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: SpinKitChasingDots(
              color: Colors.black,
              duration: Duration(seconds: 1),
            ));
          }
          if (snapshot.hasError) {
            return Center(
                child: SpinKitChasingDots(
              color: Colors.black,
              duration: Duration(seconds: 1),
            ));
          }
          snapshot.data.documents.forEach((doc) {
            markers[MarkerId(doc.documentID)] = Marker(
                consumeTapEvents: true,
                markerId: MarkerId(doc.documentID),
                position: LatLng(doc.data['coordinate'].latitude,
                    doc.data['coordinate'].longitude));
          });
          return GoogleMap(
            initialCameraPosition: cameraPosition,
            mapType: MapType.hybrid,
            markers: Set<Marker>.of(markers.values),
          );
        },
      ),
    );
  }
}
