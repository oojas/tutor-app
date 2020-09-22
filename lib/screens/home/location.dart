import 'dart:async';
import 'package:tutorappnew/loading.dart';
import 'package:tutorappnew/models/subject.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location1 extends StatefulWidget {
  final Teacher teacher;
  Location1({this.teacher});
  @override
  _Location1State createState() => _Location1State();
}

class _Location1State extends State<Location1> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition initialCameraPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Marker teacherMarker;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    initialCameraPosition = CameraPosition(
        target: LatLng(
            widget.teacher.point.latitude, widget.teacher.point.longitude),
        zoom: 15);
    markers.clear();
    teacherMarker = Marker(
      markerId: MarkerId(widget.teacher.uid),
      position:
          LatLng(widget.teacher.point.latitude, widget.teacher.point.longitude),
      infoWindow: InfoWindow(
        title: "Teacher Position",
      ),
    );
    markers[MarkerId(widget.teacher.uid)] = teacherMarker;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
              child: GoogleMap(
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: false,
                mapType: MapType.hybrid,
                markers: Set<Marker>.of(markers.values),
                initialCameraPosition: initialCameraPosition,
              ),
            ),
          );
  }
}
