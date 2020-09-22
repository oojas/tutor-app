import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tutorappnew/models/subject.dart';
import 'package:tutorappnew/screens/home/location.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tutorappnew/screens/payment/PayStack.dart';
import 'package:tutorappnew/screens/payment/selectPaymentOption.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherInfo extends StatefulWidget {
  Teacher teacher;
  String studentUid;
  TeacherInfo({this.teacher, this.studentUid});
  @override
  _TeacherInfoState createState() => _TeacherInfoState();
}

class _TeacherInfoState extends State<TeacherInfo> {
  Razorpay razorpay;
  CameraPosition initialCameraPosition;
  File _image;
  String url =
      "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlerPaymentFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlerExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  void _handlerPaymentSuccess(
      PaymentSuccessResponse paymentSuccessResponse) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Payment Successfully completed"),
        actions: [
          FlatButton(
            child: Text("Okay"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
    Firestore.instance
        .collection('Users')
        .document(widget.teacher.uid)
        .updateData({
      'enrolledStudents': FieldValue.arrayUnion([widget.studentUid])
    });
    Firestore.instance
        .collection('Users')
        .document(widget.studentUid)
        .updateData({
      'classes': FieldValue.increment(1),
      'newclass': FieldValue.increment(1)
    });
    Firestore.instance
        .collection('coursesPurchased')
        .document(widget.studentUid)
        .collection('coursesPurchased')
        .add({
      'name': widget.teacher.name,
      'description': widget.teacher.description,
      'age': widget.teacher.age,
      'email': widget.teacher.email,
      'exp': widget.teacher.exp,
      'phoneno': widget.teacher.phoneno,
      'photo': widget.teacher.photo,
      'subjects': widget.teacher.subjects,
      'uid': widget.teacher.uid,
      'url': widget.teacher.url,
      'point': widget.teacher.point,
      'enrolledStudents': widget.teacher.enrolledStudents,
      'charge': widget.teacher.charge,
      'curricullum': widget.teacher.curricullum
    });
  }

  void _handlerPaymentFailure(PaymentFailureResponse paymentSuccessResponse) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Payment Failed"),
      ),
    );
  }

  void _handlerExternalWallet(ExternalWalletResponse paymentSuccessResponse) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("External wallet selected"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teacher.name),
        actions: [
          FlatButton(
            onPressed:
                widget.teacher.enrolledStudents.contains(widget.studentUid)
                    ? null
                    : () async {
                        Firestore.instance
                            .collection('Users')
                            .document(widget.studentUid)
                            .get()
                            .then((value) async {
                          var options = {
                            'key': 'rzp_test_RsNwyLfj3IL7fr',
                            'amount': double.parse(widget.teacher.charge) *
                                100, //amount is amount/100
                            'name': widget.teacher.name,
                            'description': widget.teacher.subjects,
                            'prefill': {
                              'contact': value.data['phoneno'],
                              'email': value.data['emailid']
                            },
                            'theme': {'color': '#008080'}
                          };
                          // razorpay.open(options);

                          //this is for paystack
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => PaymentPage(
                          //    teacher: widget.teacher,
                          //    studentUid: widget.studentUid,
                          //    studentEmail:value['emailid']
                          //   ),
                          // ));

                          //this is for paypal
                          // final platform=MethodChannel('payment');
                          // await platform.invokeMethod('paymentProcess');
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SelectPaymentOption(
                              studentEmail: value['emailid'],
                              studentUid: widget.studentUid,
                              teacher: widget.teacher,
                            ),
                          ));
                        });
                      },
            child: Text(
              widget.teacher.enrolledStudents.contains(widget.studentUid)
                  ? "Already Purchased"
                  : "Proceed to buy",
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
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
                      backgroundImage: (_image != null)
                          ? FileImage(
                              _image,
                            )
                          : NetworkImage(
                              widget.teacher.url == null
                                  ? url
                                  : widget.teacher.url,
                            ),
                      radius: 60.0,
                    ),
                  ),
                ),
                Text(
                  widget.teacher.name ?? 'N/A',
                  style: TextStyle(fontSize: 20, fontFamily: "Cocogoose"),
                ),
                Text(
                  widget.teacher.email ?? 'N/A',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0.0,
                  color: Colors.teal.withOpacity(0.3),
                  child: ListTile(
                    leading: Text(
                      "Subjects",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w900),
                    ),
                    trailing: Text(
                      widget.teacher.subjects ?? 'N/A',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.teal.withOpacity(0.3),
                  elevation: 0.0,
                  child: ListTile(
                    leading: Text(
                      "Experience",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w900),
                    ),
                    trailing: Text(
                      widget.teacher.exp ?? 'N/A',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.teal.withOpacity(0.3),
                  elevation: 0.0,
                  child: ListTile(
                    leading: Text(
                      "Mobile No",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w900),
                    ),
                    trailing: Text(
                      widget.teacher.phoneno ?? 'N/A',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.teal.withOpacity(0.3),
                  elevation: 0.0,
                  child: ListTile(
                    leading: Text(
                      "Age",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w900),
                    ),
                    trailing: Text(
                      widget.teacher.age ?? 'N/A',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.teal.withOpacity(0.3),
                  elevation: 0.0,
                  child: ListTile(
                    leading: Text(
                      "Charge per hour",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w900),
                    ),
                    trailing: Text(
                      "\$" + widget.teacher.charge ?? 'N/A',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.teal.withOpacity(0.3),
                  elevation: 0.0,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Location1(
                              teacher: widget.teacher,
                            ),
                          ));
                    },
                    title: Center(
                      child: Text(
                        "Location",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                widget.teacher.curricullum == null ||
                        widget.teacher.curricullum.trim() == ""
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                            color: Colors.teal.withOpacity(0.3),
                            elevation: 0.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Curricullum",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.teacher.curricullum == null
                                      ? ""
                                      : widget.teacher.curricullum),
                                )
                              ],
                            )),
                      ),
                widget.teacher.curricullumPdf == null ||
                        widget.teacher.curricullumPdf.trim() == ""
                    ? Container()
                    : Card(
                        color: Colors.teal.withOpacity(0.3),
                        elevation: 0.0,
                        child: ListTile(
                          leading: Text(
                            "Curricullum PDF",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w900),
                          ),
                          trailing: IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () async {
                                if (await canLaunch(
                                    widget.teacher.curricullumPdf)) {
                                  launch(widget.teacher.curricullumPdf);
                                }
                              }),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
