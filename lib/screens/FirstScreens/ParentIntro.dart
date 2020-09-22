import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorappnew/screens/FirstScreens/parentPendingRequest.dart';
import 'package:tutorappnew/screens/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:io';
import 'package:tutorappnew/loading.dart';
import 'package:tutorappnew/services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ParentIntro extends StatefulWidget {
  final String uid;
  ParentIntro({this.uid});
  @override
  _ParentIntroState createState() => _ParentIntroState();
}

class _ParentIntroState extends State<ParentIntro> {
  final _formkey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;
  DateTime _dateTime;
  String formattedDate = '';
  AuthService _authservice = AuthService();
  final int _totalPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  String name = '',
      emailid = '',
      phoneno = '',
      age = '',
      exp = '',
      subjects = '',
      childemailid = '',
      childphoneno = '',
      url =
          "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60";
  bool loading = false, nextpage = false;
  ScrollController c;

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

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
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
                    ],
                  ),
                  // Positioned(
                  //   bottom: 40,
                  //   left: MediaQuery.of(context).size.width * .05,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                FadeInLeft(
                    child: Text(
                  "Welcome",
                  style: TextStyle(fontFamily: "Cocogoose"),
                )),
                FadeInUp(
                    child: Container(
                  width: 20,
                  height: 2,
                  color: Colors.teal,
                )),
                FadeInRight(
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
                  child: Text("Name",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w900)),
                ),
                SizedBox(
                  height: 10.0,
                ),
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
                  delay: Duration(milliseconds: 600),
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
                  delay: Duration(milliseconds: 600),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        initialValue: emailid,
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
                  delay: Duration(milliseconds: 700),
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
                  delay: Duration(milliseconds: 700),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        initialValue: phoneno,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(border: InputBorder.none),
                        validator: (value) =>
                            value.length <= 9 ? 'Enter Mobile No' : null,
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
                    RaisedButton(
                      onPressed: () {
                        if (phoneno != null) {
                          if (phoneno.trim().length != "") {
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
                              'approved': 0
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
                          SnackBar snackBar =
                              new SnackBar(content: Text("Enter phone number"));
                          scaffoldKey.currentState.showSnackBar(snackBar);
                        }
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
      child: Form(
        key: _formkey,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                FadeInLeft(
                    child: Text(
                  "Welcome",
                  style: TextStyle(fontFamily: "Cocogoose"),
                )),
                FadeInUp(
                    child: Container(
                  width: 20,
                  height: 2,
                  color: Colors.teal,
                )),
                FadeInRight(
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
                  child: Text(
                    "Enter your child's Email Id",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
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
                        initialValue: name,
                        decoration: InputDecoration(border: InputBorder.none),
                        validator: (value) =>
                            value.isEmpty ? 'Enter your Child EmailID' : null,
                        onChanged: (value) =>
                            setState(() => childemailid = value),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                FadeInLeft(
                  delay: Duration(milliseconds: 700),
                  child: Text(
                    "Enter your child Phone No",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FadeInRight(
                  delay: Duration(milliseconds: 700),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        initialValue: phoneno,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(border: InputBorder.none),
                        validator: (value) =>
                            value.length <= 9 ? 'Enter child Mobile No' : null,
                        onChanged: (value) =>
                            setState(() => childphoneno = value),
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
                    RaisedButton(
                      onPressed: () {
                        if (childphoneno != null) {
                          if (childphoneno.trim().length != "") {
                            setState(() {
                              nextpage = true;
                            });
                            Firestore.instance
                                .collection('Users')
                                .document(widget.uid)
                                .setData({
                              'childemailid': childemailid,
                              'childphoneno': childphoneno,
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
                                content:
                                    Text("Enter valid child phone number"));
                            scaffoldKey.currentState.showSnackBar(snackBar);
                          }
                        } else {
                          SnackBar snackBar = new SnackBar(
                              content: Text("Enter child phone number"));
                          scaffoldKey.currentState.showSnackBar(snackBar);
                        }
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThirdPageContent() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FadeInLeft(
                delay: Duration(milliseconds: 700),
                child: Text(
                  "Welcome",
                  style: TextStyle(fontFamily: "Cocogoose"),
                )),
            FadeInUp(
                child: Container(
              width: 20,
              height: 2,
              color: Colors.teal,
            )),
            FadeInRight(
              delay: Duration(milliseconds: 700),
              child: Text(
                "Let's Begin",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w900),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            FadeInLeft(
              delay: Duration(milliseconds: 750),
              child: Text("Upload Image",
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900)),
            ),
            SizedBox(
              height: 10.0,
            ),
            ElasticInLeft(
              delay: Duration(milliseconds: 750),
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
              delay: Duration(milliseconds: 800),
              child: Text(
                "Age",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            FadeInRight(
              delay: Duration(milliseconds: 800),
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
                              initialDate: _dateTime == null
                                  ? DateTime.now()
                                  : _dateTime,
                              firstDate: DateTime(2001),
                              lastDate: DateTime(2021))
                          .then((date) {
                        setState(() {
                          _dateTime = date;
                          formattedDate =
                              DateFormat("dd-MM-yyyy").format(date).toString();
                        });
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
                  delay: Duration(milliseconds: 850),
                  child: RaisedButton(
                    onPressed: () async {
                      setState(() {
                        nextpage = true;
                      });
                      Firestore.instance
                          .collection('Users')
                          .document(widget.uid)
                          .setData(
                        {
                          'url': url,
                          'age': formattedDate,
                          'userType': "Parent",
                          'uid': widget.uid
                        },
                        merge: true,
                      ).whenComplete(() async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('seen', true);
                        await prefs.setString('userType', 'Parent');
                        Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                            builder: (context) => ParentPendingRequest(
                              uid: widget.uid,
                            ),
                          ),
                        );
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
    );
  }

  Widget _buildPageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: isCurrentPage ? 18.0 : 10.0,
      width: isCurrentPage ? 18.0 : 10.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
