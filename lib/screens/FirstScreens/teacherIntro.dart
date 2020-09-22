import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorappnew/loading.dart';
import 'package:tutorappnew/screens/FirstScreens/teacherPendingRequest.dart';
import 'package:tutorappnew/screens/home/changeLocation.dart';
import 'package:tutorappnew/screens/home/home.dart';
import 'package:tutorappnew/screens/wrapper.dart';
import 'package:tutorappnew/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class TeacherIntro extends StatefulWidget {
  final String uid;
  TeacherIntro({this.uid});
  @override
  _TeacherIntroState createState() => _TeacherIntroState();
}

class _TeacherIntroState extends State<TeacherIntro> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;
  DateTime _dateTime;
  String formattedDate = '';
  AuthService _authservice = AuthService();
  final int _totalPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  TextEditingController curricullumController = TextEditingController();
  String name = '',
      emailid = '',
      phoneno = '',
      age = '',
      exp = '',
      subjects = '',
      charge = '',
      selectedCategory,
      url =
          "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60";
  bool loading = false, nextpage = false, location = false;
  File curricullumPdf;
  String pdfname;
  ScrollController c;
  List<String> categories = ['Arts', 'Science', 'Social Science', 'Others'];
  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition initialCameraPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Color locatio = Color(0XFFEFF3F6);
  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    c = new PageController();
    getdata();
  }

  Future uploadPic() async {
    // ignore: unused_local_variable
    String fileName = _image.path, upurl = '';
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(widget.uid);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    upurl = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      url = upurl;
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    uploadPic();
  }

  Future getdata() async {
    await _authservice.getCurrentUser().then((value) {
      setState(() {
        name = value['2'];
        emailid = value['5'];
        phoneno = value['4'];
        url = value['3'];
        loading = false;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            key: scaffoldKey,
            body: Container(
              child: Stack(
                children: [
                  PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      _currentPage = page;
                      setState(() {});
                    },
                    children: <Widget>[
                      _buildFirstPageContent(),
                      _buildSecondPageContent(),
                      _buildThirdPageContent(),
                      _buildFourthPageContent(),
                    ],
                  ),
                  // Positioned(
                  //   top:200,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Container(
                  //         alignment: Alignment.center,
                  //         width: MediaQuery.of(context).size.width * .9,
                  //         child: Row(
                  //           children: [
                  //             Container(
                  //               child: Row(children: [
                  //                 for (int i = 0; i < _totalPages; i++)
                  //                   i == _currentPage
                  //                       ? _buildPageIndicator(true)
                  //                       : _buildPageIndicator(false)
                  //               ]),
                  //             ),
                  //             Spacer(),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          );
  }

  Widget _buildFirstPageContent() {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                FadeInLeft(
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    "Welcome",
                    style: TextStyle(fontFamily: "Cocogoose"),
                  ),
                ),
                FadeInUp(
                    child: Container(
                  width: 20,
                  height: 2,
                  color: Colors.teal,
                )),
                FadeInRight(
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    "Let's Begin",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                FadeInLeft(
                  delay: Duration(milliseconds: 500),
                  duration: Duration(milliseconds: 500),
                  child: Text("Name",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w900)),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FadeInRight(
                  delay: Duration(milliseconds: 700),
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        initialValue: name,
                        decoration: InputDecoration(border: InputBorder.none),
                        validator: (value) =>
                            value.isEmpty ? 'Enter Name' : null,
                        onChanged: (value) => setState(() => name = value),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                FadeInLeft(
                  delay: Duration(milliseconds: 700),
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    "Email ID",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FadeInRight(
                  delay: Duration(milliseconds: 700),
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        initialValue: emailid,
                        enabled: false,
                        decoration: InputDecoration(border: InputBorder.none),
                        validator: (value) =>
                            value.isEmpty ? 'Enter Email ID' : null,
                        onChanged: (value) => setState(() => emailid = value),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                FadeInLeft(
                  delay: Duration(milliseconds: 900),
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    "Phone No",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FadeInRight(
                  delay: Duration(milliseconds: 900),
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        initialValue: phoneno,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            errorStyle: TextStyle(
                              color: Colors.black,
                            )),
                        onChanged: (value) => setState(() => phoneno = value),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElasticInRight(
                      delay: Duration(seconds: 1),
                      child: RaisedButton(
                        onPressed: () {
                          if (phoneno != null) {
                            if (phoneno.length >= 10) {
                              setState(() {
                                nextpage = true;
                              });
                              Firestore.instance
                                  .collection('Users')
                                  .document(widget.uid)
                                  .setData({
                                'name': name,
                                'emailid': emailid,
                                'phoneno': phoneno,
                              }, merge: true).whenComplete(() {
                                if (_formkey.currentState.validate()) {
                                  _pageController.animateTo(
                                      MediaQuery.of(context).size.width *
                                          (_currentPage + 1),
                                      duration: new Duration(milliseconds: 500),
                                      curve: Curves.easeIn);
                                  setState(() {
                                    nextpage = false;
                                  });
                                }
                              });
                            } else {
                              SnackBar snackBar = new SnackBar(
                                  content: Text("Enter valid phone number"));
                              scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                          } else {
                            SnackBar snackBar = new SnackBar(
                                content: Text("Enter phone number"));
                            scaffoldKey.currentState.showSnackBar(snackBar);
                          }
                        },
                        color: Colors.teal,
                        shape:
                            CircleBorder(side: BorderSide(color: Colors.teal)),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Icon(
                            FontAwesomeIcons.greaterThan,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondPageContent() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 80),
              FadeInLeft(
                  delay: Duration(seconds: 1),
                  child: Text(
                    "Welcome",
                    style: TextStyle(fontFamily: "Cocogoose"),
                  )),
              FadeInUp(
                delay: Duration(seconds: 1),
                child: Container(width: 20, height: 3, color: Colors.teal),
              ),
              FadeInRight(
                delay: Duration(seconds: 1),
                child: Text(
                  "Let's Begin",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              FadeInLeft(
                delay: Duration(milliseconds: 1200),
                child: Text("Upload Image",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900)),
              ),
              SizedBox(
                height: 10.0,
              ),
              ElasticInLeft(
                delay: Duration(milliseconds: 1200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.teal.withOpacity(0.4),
                        child: ClipOval(
                          child: new SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: (_image != null)
                                ? Image.file(
                                    _image,
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    url,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.camera,
                          size: 30.0,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              FadeInLeft(
                delay: Duration(milliseconds: 1300),
                child: Text(
                  "Date of birth",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              FadeInRight(
                delay: Duration(milliseconds: 1300),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: FlatButton(
                      child: Text(
                          formattedDate == null ? 'DD/MM/YYYY' : formattedDate),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate:
                              _dateTime == null ? DateTime.now() : _dateTime,
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                          initialDatePickerMode: DatePickerMode.year,
                        ).then((date) {
                          if (date != null) {
                            Duration duration = DateTime.now().difference(date);
                            age = (duration.inDays ~/ 365).toString();
                            setState(() {
                              _dateTime = date;
                              formattedDate = DateFormat("dd-MM-yyyy")
                                  .format(date)
                                  .toString();
                            });
                          }
                        });
                      },
                    )),
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElasticInRight(
                    delay: Duration(milliseconds: 1400),
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          nextpage = true;
                        });
                        Firestore.instance
                            .collection('Users')
                            .document(widget.uid)
                            .setData(
                          {'url': url, 'birthday': formattedDate, 'age': age},
                          merge: true,
                        ).whenComplete(() {
                          _pageController.animateTo(
                              MediaQuery.of(context).size.width *
                                  (_currentPage + 1),
                              duration: new Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                          setState(() {
                            nextpage = false;
                          });
                        });
                      },
                      color: Colors.teal,
                      shape: CircleBorder(side: BorderSide(color: Colors.teal)),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Icon(
                          FontAwesomeIcons.greaterThan,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThirdPageContent() {
    return SingleChildScrollView(
      child: Form(
        key: _formkey2,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                FadeInLeft(
                  delay: Duration(milliseconds: 1000),
                  child: Text(
                    "Welcome",
                    style: TextStyle(fontFamily: "Cocogoose"),
                  ),
                ),
                FadeInUp(
                    child: Container(
                  width: 20,
                  height: 2,
                  color: Colors.teal,
                )),
                FadeInRight(
                  delay: Duration(milliseconds: 1050),
                  child: Text(
                    "Let's Begin",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                FadeInLeft(
                  delay: Duration(milliseconds: 1100),
                  child: Text("Subjects",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w900)),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FadeInRight(
                  delay: Duration(milliseconds: 1100),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        initialValue: subjects,
                        decoration: InputDecoration(border: InputBorder.none),
                        validator: (value) =>
                            value.isEmpty ? 'Enter Subjects' : null,
                        onChanged: (value) => setState(() => subjects = value),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                FadeInLeft(
                  delay: Duration(milliseconds: 1150),
                  child: Text(
                    "Experience (in years)",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FadeInRight(
                  delay: Duration(milliseconds: 1150),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        initialValue: exp,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(border: InputBorder.none),
                        validator: (value) =>
                            value.length <= 9 ? 'Enter your Exp' : null,
                        onChanged: (value) => setState(() => exp = value),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                FadeInLeft(
                  delay: Duration(milliseconds: 1200),
                  child: Text(
                    "Charge (per hour)",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(height: 10),
                FadeInRight(
                  delay: Duration(milliseconds: 1150),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        initialValue: charge,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(border: InputBorder.none),
                        onChanged: (value) => setState(() => charge = value),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FadeInLeft(
                  delay: Duration(milliseconds: 1200),
                  child: Text(
                    "Your Location",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FadeInRight(
                  delay: Duration(milliseconds: 1200),
                  child: Container(
                      decoration: BoxDecoration(
                        color: locatio,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: FlatButton(
                        child: Text('Set Location'),
                        onPressed: () {
                          initialCameraPosition = CameraPosition(
                              target: LatLng(22.78546, 78.95632), zoom: 15);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeLocation(
                                    initialCameraPosition, widget.uid),
                              )).then((value) {
                            if (value != null) {
                              setState(() {
                                locatio = Colors.green;
                                location = true;
                              });
                            }
                          });
                        },
                      )),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElasticInRight(
                      delay: Duration(milliseconds: 1300),
                      child: RaisedButton(
                        onPressed: () async {
                          setState(() {
                            nextpage = true;
                          });
                          if (location) {
                            _pageController.animateTo(
                                MediaQuery.of(context).size.width *
                                    (_currentPage + 1),
                                duration: new Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                            setState(() {
                              nextpage = false;
                            });
                          } else {
                            setState(() {
                              locatio = Colors.red;
                            });
                          }
                        },
                        color: Colors.teal,
                        shape:
                            CircleBorder(side: BorderSide(color: Colors.teal)),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Icon(
                            FontAwesomeIcons.greaterThan,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFourthPageContent() {
    return SingleChildScrollView(
      child: Form(
        key: _formkey2,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                FadeInLeft(
                  delay: Duration(milliseconds: 500),
                  child: Text(
                    "Welcome",
                    style: TextStyle(fontFamily: "Cocogoose"),
                  ),
                ),
                FadeInUp(
                    child: Container(
                  width: 20,
                  height: 2,
                  color: Colors.teal,
                )),
                FadeInRight(
                  delay: Duration(milliseconds: 500),
                  child: Text(
                    "Let's Begin",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                FadeInLeft(
                  child: Text(
                    "Enter course curricullum",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(height: 5),
                FadeInRight(
                  delay: Duration(milliseconds: 500),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: curricullumController,
                        textInputAction: TextInputAction.newline,
                        maxLines: 10,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter text or upload pdf below"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                FadeInRight(
                  delay: Duration(milliseconds: 500),
                  child: GestureDetector(
                    onTap: () async {
                      curricullumPdf = await FilePicker.getFile(
                          allowCompression: true,
                          type: FileType.custom,
                          allowedExtensions: ['pdf']);
                      if (curricullumPdf != null) {
                        print(curricullumPdf.path);
                        int index = curricullumPdf.path.lastIndexOf('/');
                        pdfname = curricullumPdf.path.substring(index + 1);
                        setState(() {});
                      }
                    },
                    child: Card(
                      elevation: 6.0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: curricullumPdf == null
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Choose PDF",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ))
                            : Center(
                                child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        pdfname,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            curricullumPdf = null;
                                            pdfname = null;
                                          });
                                        })
                                  ],
                                ),
                              )),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeInLeft(
                      delay: Duration(milliseconds: 500),
                      child: Text(
                        "Choose category",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(width: 20),
                    FadeInRight(
                      delay: Duration(milliseconds: 500),
                      child: DropdownButton(
                          hint: Text("Select Category"),
                          value: selectedCategory,
                          items: categories
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElasticInRight(
                      delay: Duration(milliseconds: 1300),
                      child: RaisedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                setState(() {
                                  nextpage = true;
                                });
                                if (curricullumPdf == null ||
                                    selectedCategory == null) {
                                  if (curricullumPdf == null) {
                                    SnackBar snackBar = new SnackBar(
                                      content: Text(
                                          "Please upload pdf or Manually type curricullum."),
                                    );
                                    scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  } else if (selectedCategory == null) {
                                    SnackBar snackBar = new SnackBar(
                                      content: Text("Please select a category"),
                                    );
                                    scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  }
                                } else {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('seen', true);
                                  StorageTaskSnapshot storageTaskSnapshot =
                                      await FirebaseStorage.instance
                                          .ref()
                                          .child('curricullumPdf/$pdfname' +
                                              DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString())
                                          .putFile(curricullumPdf)
                                          .onComplete;
                                  String downloadUrl = await storageTaskSnapshot
                                      .ref
                                      .getDownloadURL();
                                  Firestore.instance
                                      .collection('Users')
                                      .document(widget.uid)
                                      .setData({
                                    'exp': exp,
                                    'subjects': subjects,
                                    'charge': charge,
                                    'approved': 0,
                                    'curricullum': curricullumController.text,
                                    'curricullumPdf': downloadUrl,
                                    'category': selectedCategory
                                  }, merge: true).whenComplete(() async {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    preferences.setString(
                                        'userType', "Teacher");
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) =>
                                          TeacherPendingRequest(
                                        imageUrl: url,
                                        name: name,
                                        uid: widget.uid,
                                      ),
                                    ));
                                  });
                                }
                              },
                        color: Colors.teal,
                        shape:
                            CircleBorder(side: BorderSide(color: Colors.teal)),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: isLoading
                              ? SpinKitCircle(
                                  duration: Duration(seconds: 1),
                                  color: Colors.white,
                                  size: 20,
                                )
                              : Icon(
                                  FontAwesomeIcons.greaterThan,
                                  size: 20,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLocation() {
    return StreamBuilder<DocumentSnapshot>(
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
        try {
          initialCameraPosition = initializeCameraPosition(snapshot);

          return Container(
            height: 150,
            width: MediaQuery.of(context).size.width - 40,
            child: GoogleMap(
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
                onTap: (latlng) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChangeLocation(initialCameraPosition, widget.uid),
                      )).then((value) async {
                    if (value != null) {
                      markers.clear();
                      GoogleMapController controller = await _controller.future;
                      controller.animateCamera(CameraUpdate.newCameraPosition(
                          new CameraPosition(
                              zoom: 15,
                              target:
                                  LatLng(value.latitude, value.longitude))));
                      Marker marker = Marker(
                          consumeTapEvents: true,
                          markerId: MarkerId(widget.uid),
                          position: LatLng(value.latitude, value.longitude));
                      markers[MarkerId(widget.uid)] = marker;
                    }
                  });
                },
                zoomGesturesEnabled: false,
                scrollGesturesEnabled: false,
                mapType: MapType.hybrid,
                markers: Set<Marker>.of(markers.values),
                initialCameraPosition: initialCameraPosition),
          );
        } on StateError catch (e) {
          print(e.toString());
        }
      },
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

  Widget _buildPageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: isCurrentPage ? 18.0 : 10.0,
      width: isCurrentPage ? 18.0 : 10.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.teal : Colors.tealAccent,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
