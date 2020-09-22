import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StudentInfo extends StatefulWidget {
  String imageUrl, name, phoneno, emailid;
  GeoPoint location;
  StudentInfo(
      {this.imageUrl, this.name, this.emailid, this.location, this.phoneno});
  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  CameraPosition cameraPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cameraPosition = new CameraPosition(
        target: LatLng(widget.location.latitude, widget.location.longitude),
        zoom: 17);
    Marker marker = Marker(
      markerId: MarkerId("studentPostion"),
      position: LatLng(widget.location.latitude, widget.location.longitude),
    );
    markers[MarkerId("studentPostion")] = marker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.name),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AvatarGlow(
                glowColor: Colors.teal,
                endRadius: 90.0,
                duration: Duration(milliseconds: 1000),
                repeat: true,
                showTwoGlows: true,
                repeatPauseDuration: Duration(milliseconds: 100),
                child: Material(
                  elevation: 8.0,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
                    radius: 60.0,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                widget.emailid,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Location",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: "Cocogoose",
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 150,
                      child: GoogleMap(
                        initialCameraPosition: cameraPosition,
                        mapType: MapType.hybrid,
                        markers: markers.values.toSet(),
                      )),
                ],
              ),
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Phone Number",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: "Cocogoose",
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.phoneno,
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        OutlineButton(
                          borderSide: BorderSide(color: Colors.teal),
                          onPressed: () {
                            final phoneCall = FlutterPhoneState.startPhoneCall(
                                widget.phoneno);
                          },
                          child: Text(
                            'Call',
                            style: TextStyle(fontFamily: "Cocogoose"),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
