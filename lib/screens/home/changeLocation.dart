import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class ChangeLocation extends StatefulWidget {
  CameraPosition initialCameraPosition;
  String uid;
  ChangeLocation(this.initialCameraPosition, this.uid);
  @override
  _ChangeLocationState createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool isLoading = false;
  GeoPoint geoPoint;
  final geo = Geoflutterfire();
  GeoFirePoint mypoint;
  @override
  void initState() {
    super.initState();
    geoPoint = GeoPoint(widget.initialCameraPosition.target.latitude,
        widget.initialCameraPosition.target.longitude);
    mypoint = geo.point(
        latitude: widget.initialCameraPosition.target.latitude,
        longitude: widget.initialCameraPosition.target.longitude);
    Marker marker = Marker(
      markerId: MarkerId("1234"),
      position: widget.initialCameraPosition.target,
    );
    markers[MarkerId("1234")] = marker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: Set<Marker>.of(markers.values),
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
            mapType: MapType.hybrid,
            initialCameraPosition: widget.initialCameraPosition,
            onTap: (selectedLatlng) async {
              geoPoint =
                  GeoPoint(selectedLatlng.latitude, selectedLatlng.longitude);
              markers.clear();
              mypoint = geo.point(
                  latitude: selectedLatlng.latitude,
                  longitude: selectedLatlng.longitude);
              Marker marker = Marker(
                markerId: MarkerId("1234"),
                position: selectedLatlng,
              );
              markers[MarkerId("1234")] = marker;
              setState(() {});
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  new CameraPosition(
                    target: selectedLatlng,
                    zoom: 17,
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () async {
                final GoogleMapController controller = await _controller.future;
                Position position = await Geolocator().getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.bestForNavigation);
                geoPoint = GeoPoint(position.latitude, position.longitude);
                mypoint = geo.point(
                  latitude: geoPoint.latitude,
                  longitude: geoPoint.longitude);
                controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 17)));
                markers.clear();
                Marker marker = Marker(
                  markerId: MarkerId("1234"),
                  position: LatLng(geoPoint.latitude, geoPoint.longitude),
                );
                markers[MarkerId("1234")] = marker;
                setState(() {});
              },
              child: Container(
                  margin: EdgeInsets.only(right: 70, bottom: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.my_location,
                    size: 30,
                    color: Colors.blue,
                  )),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: isLoading
                  ? null
                  : () {
                      setState(() {
                        isLoading = true;
                      });
                      Firestore.instance
                          .collection('Users')
                          .document(widget.uid)
                          .setData({'location': mypoint.data},
                              merge: true).then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pop(geoPoint);
                      });
                    },
              child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isLoading
                        ? Container(
                            width: 130,
                            height: 20,
                            child: Center(
                                child: Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ))))
                        : Container(
                            width: 130,
                            height: 20,
                            child: Text(
                              "Update location",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 20),
                            ),
                          ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
