import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutorappnew/loading.dart';
import 'package:tutorappnew/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tutorappnew/screens/home/changeLocation.dart';

class EditProfile extends StatefulWidget {
  String uid;
  EditProfile({this.uid});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  AuthService _authservice = AuthService();
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition initialCameraPosition;
  bool isLoading = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  File _image;
  bool userfield = false, birthdayfield = false;
  @override
  void initState() {
    super.initState();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('Users')
            .document(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SpinKitCircle(
              duration: Duration(seconds: 1),
              color: Colors.teal,
              size: 20,
            );
          }
          if (snapshot.hasError) {
            return SpinKitCircle(
              duration: Duration(seconds: 1),
              color: Colors.teal,
              size: 20,
            );
          }
          birthdayController.text = snapshot.data['birthday'];
          usernameController.text = snapshot.data['username'];
          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.black,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: FadeInLeft(
                        child: Text(
                          "Profile",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: "Cocogoose"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 240,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    height: 200,
                    padding: EdgeInsets.only(left: 12),
                    width: MediaQuery.of(context).size.width,
                    child: buildLocation(),
                  ),
                  isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SpinKitCircle(
                            color: Colors.teal,
                            duration: Duration(seconds: 1),
                            size: 20,
                          ),
                        )
                      : OutlineButton(
                          borderSide: BorderSide(color: Colors.teal),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  String newUrl;
                                  if (_image != null) {
                                    StorageTaskSnapshot storageTaskSnapshot =
                                        await FirebaseStorage.instance
                                            .ref()
                                            .child(
                                                'userprofile/${_image.path}' +
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch
                                                        .toString())
                                            .putFile(_image)
                                            .onComplete;
                                    newUrl = await storageTaskSnapshot.ref
                                        .getDownloadURL();
                                  }

                                  Firestore.instance
                                      .collection('Users')
                                      .document(widget.uid)
                                      .setData({
                                    'username': usernameController.text,
                                    'birthday': birthdayController.text,
                                    'url': _image != null
                                        ? newUrl
                                        : snapshot.data['url']
                                  }, merge: true).then((value) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 70, right: 70),
                            child: Text("Submit"),
                          ),
                        )
                ],
              ),
              Positioned(
                top: 130,
                left: 10,
                child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 280,
                      width: MediaQuery.of(context).size.width - 30,
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Text(snapshot.data['username'],
                                style: TextStyle(
                                    fontSize: 20, fontFamily: "Cocogoose")),
                            Text(snapshot.data['emailid'],
                                style: TextStyle(
                                    fontSize: 10, fontFamily: "Roboto")),
                            FadeInUp(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 200,
                                    child: TextFormField(
                                      enabled: userfield,
                                      validator: (value) =>
                                          value.isEmpty ? 'Enter Name' : null,
                                      controller: usernameController,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        disabledBorder: InputBorder.none,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.teal, width: 2)),
                                        labelText: 'Username',
                                        labelStyle: TextStyle(
                                            fontFamily: "Roboto",
                                            fontSize: 20.0,
                                            color: Colors.teal),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        userfield = true;
                                      });
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.pen,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FadeInUp(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 200,
                                    child: TextFormField(
                                      enabled: birthdayfield,
                                      keyboardType: TextInputType.number,
                                      validator: (value) =>
                                          value.isEmpty ? 'Enter Name' : null,
                                      controller: birthdayController,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto"),
                                      decoration: InputDecoration(
                                        disabledBorder: InputBorder.none,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.teal, width: 2)),
                                        labelText: 'BirthDay',
                                        labelStyle: TextStyle(
                                            fontSize: 20.0, color: Colors.teal),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        birthdayfield = true;
                                      });
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.pen,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              Positioned(
                  top: 70,
                  left: MediaQuery.of(context).size.width / 2 - 95,
                  child: ElasticInDown(
                    duration: Duration(seconds: 2),
                    child: AvatarGlow(
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
                          backgroundImage: _image != null
                              ? FileImage(_image)
                              : snapshot.data['url'] == null ||
                                      snapshot.data['url'].trim() == ""
                                  ? AssetImage('assets/profile.png')
                                  : NetworkImage(snapshot.data['url']),
                          radius: 60.0,
                        ),
                      ),
                    ),
                  )),
              Positioned(
                top: 170,
                left: MediaQuery.of(context).size.width / 2 + 25,
                child: FadeIn(
                  child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                      ),
                      onPressed: () async {
                        await getImage();
                      }),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget buildLocation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            "Your Location",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Cocogoose"),
          ),
        ),
        StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('Users')
              .document(widget.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return loader();
            }
            if (snapshot.hasError) {
              return loader();
            }

            initialCameraPosition = initializeCameraPosition(snapshot);

            return Container(
                height: 150,
                width: MediaQuery.of(context).size.width - 30,
                child: GoogleMap(
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                    onTap: (latlng) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) =>
                            ChangeLocation(initialCameraPosition, widget.uid),
                      ))
                          .then((value) async {
                        if (value != null) {
                          print(value.latitude);
                          markers.clear();
                          GoogleMapController controller =
                              await _controller.future;
                          controller.animateCamera(
                              CameraUpdate.newCameraPosition(new CameraPosition(
                                  zoom: 15,
                                  target: LatLng(
                                      value.latitude, value.longitude))));
                          Marker marker = Marker(
                              consumeTapEvents: true,
                              markerId: MarkerId(widget.uid),
                              position:
                                  LatLng(value.latitude, value.longitude));
                          markers[MarkerId(widget.uid)] = marker;
                          setState(() {});
                        }
                      });
                    },
                    zoomGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    mapType: MapType.hybrid,
                    markers: Set<Marker>.of(markers.values),
                    initialCameraPosition: initialCameraPosition));
          },
        ),
      ],
    );
  }

  Widget loader() {
    return Container(
      height: 150,
      color: ThemeData.dark().canvasColor,
      width: MediaQuery.of(context).size.width - 40,
      child: Center(
        child: SpinKitFadingCircle(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }

  CameraPosition initializeCameraPosition(
      AsyncSnapshot<DocumentSnapshot> snapshot) {
    CameraPosition initialCameraPosition;
    if (snapshot.data['location'] == null) {
      initialCameraPosition =
          CameraPosition(target: LatLng(22.78546, 78.95632), zoom: 15);
    } else {
      markers.clear();
      initialCameraPosition = CameraPosition(
          zoom: 15,
          target: LatLng(snapshot.data['location']['geopoint'].latitude,
              snapshot.data['location']['geopoint'].longitude));
      Marker marker = Marker(
          consumeTapEvents: true,
          markerId: MarkerId(widget.uid),
          position: LatLng(snapshot.data['location']['geopoint'].latitude,
              snapshot.data['location']['geopoint'].longitude));
      markers[MarkerId(widget.uid)] = marker;
    }
    return initialCameraPosition;
  }
}

// Container(
//           color: Colors.amber,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   SizedBox(
//                     height: 20.0,
//                   ),
//                   Card(

//                     child: Column(
//                       children: [
//                         Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Align(
//                           alignment: Alignment.center,
//                           child: CircleAvatar(
//                             radius: 100,
//                             backgroundColor: Color(0xff476cfb),
//                             child: ClipOval(
//                               child: new SizedBox(
//                                 width: 180.0,
//                                 height: 180.0,
//                                 child: (_image != null)
//                                     ? Image.file(
//                                         _image,
//                                         fit: BoxFit.fill,
//                                       )
//                                     : Image.network(
//                                         url,
//                                         fit: BoxFit.fill,
//                                       ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(top: 60.0),
//                           child: IconButton(
//                             icon: Icon(
//                               FontAwesomeIcons.camera,
//                               size: 30.0,
//                             ),
//                             onPressed: () async {
//                               await getImage();
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20, right: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             width: 200,
//                             child: TextFormField(
//                               initialValue: username,
//                               enabled: userfield,
//                               validator: (value) =>
//                                   value.isEmpty ? 'Enter Name' : null,
//                               onChanged: (value) => setState(() {}),
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 20.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               decoration: InputDecoration(
//                                 labelText: 'Username',
//                                 labelStyle: TextStyle(
//                                   fontSize: 20.0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 userfield = true;
//                               });
//                             },
//                             child: Icon(
//                               FontAwesomeIcons.pen,
//                               color: Color(0xff476cfb),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20, right: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             width: 200,
//                             child: TextFormField(
//                               initialValue: birthday,
//                               enabled: birthdayfield,
//                               keyboardType: TextInputType.number,
//                               validator: (value) =>
//                                   value.isEmpty ? 'Enter Name' : null,
//                               onChanged: (value) => setState(() {}),
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 20.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               decoration: InputDecoration(
//                                 labelText: 'BirthDay',
//                                 labelStyle: TextStyle(
//                                   fontSize: 20.0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 birthdayfield = true;
//                               });
//                             },
//                             child: Icon(
//                               FontAwesomeIcons.pen,
//                               color: Color(0xff476cfb),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 20),

//                     Container(
//                       margin: EdgeInsets.all(20.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Text('Email',
//                               style: TextStyle(
//                                   color: Colors.blueGrey, fontSize: 18.0)),
//                           SizedBox(width: 20.0),
//                           Text(emailid,
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 20.0,
//                                   fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                     ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20.0,
//                   ),
//                   buildLocation(),
//                   SizedBox(
//                     height: 20.0,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       RaisedButton(
//                         color: Color(0xff476cfb),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         elevation: 4.0,
//                         splashColor: Colors.blueGrey,
//                         child: Text(
//                           'Cancel',
//                           style: TextStyle(color: Colors.white, fontSize: 16.0),
//                         ),
//                       ),
//                       RaisedButton(
//                         color: Color(0xff476cfb),
//                         onPressed: () {},
//                         elevation: 4.0,
//                         splashColor: Colors.blueGrey,
//                         child: Text(
//                           'Submit',
//                           style: TextStyle(color: Colors.white, fontSize: 16.0),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           );
