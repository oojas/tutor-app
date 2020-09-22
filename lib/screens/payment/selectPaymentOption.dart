import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tutorappnew/models/subject.dart';
import 'package:http/http.dart' as http;
import 'package:tutorappnew/screens/payment/PayStack.dart';

class SelectPaymentOption extends StatefulWidget {
  Teacher teacher;
  String studentUid;
  String studentEmail;
  SelectPaymentOption({this.studentEmail, this.studentUid, this.teacher});
  @override
  _SelectPaymentOptionState createState() => _SelectPaymentOptionState();
}

class _SelectPaymentOptionState extends State<SelectPaymentOption> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Select payment option"), elevation: 0.0),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !isLoading
                ? InkWell(
                    splashColor: Colors.teal,
                    onTap: () async {
                      var request = BraintreeDropInRequest(
                        tokenizationKey: "sandbox_24hcq386_zymjm6sr8d4hwb22",
                        collectDeviceData: true,
                        paypalRequest: BraintreePayPalRequest(
                          amount: widget.teacher.charge,
                          displayName: 'Tutor App',
                          currencyCode: "USD",
                        ),
                        cardEnabled: false,
                      );
                      BraintreeDropInResult result =
                          await BraintreeDropIn.start(request);
                      if (result != null) {
                        showNonce(result.paymentMethodNonce);
                      } else {
                        showDialog2();
                      }
                    },
                    child: Card(
                        elevation: 6,
                        child: Image.asset('assets/paypal1.png',
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.7)),
                  )
                : Center(
                    child: Column(
                      children: [
                        SpinKitCircle(
                          duration: Duration(seconds: 1),
                          color: Colors.grey,
                        ),
                        Container(
                          width: 180,
                          child: Text(
                            'Please do not press back button payment is under process!!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  void showNonce(BraintreePaymentMethodNonce nonce) async {
    setState(() {
      isLoading = true;
    });
    http.Response responseData = await http
        .post('https://forvm-286217.uc.r.appspot.com/checkouts', body: {
      'amount': widget.teacher.charge.toString(),
      'payment_method_nonce': nonce.nonce
    });
    dynamic transactionDetails = json.decode(responseData.body);
    print(transactionDetails);
    if (transactionDetails != null) {
      setState(() {
        isLoading = false;
      });
      if (transactionDetails != "PAYMENT FAIL HO GAYI HAI") {
        if (transactionDetails['transaction'] != null) {
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
            'curricullum': widget.teacher.curricullum,
            'curricullumPdf': widget.teacher.curricullumPdf,
            'transactionDetails': transactionDetails
          });
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          showDialog1(transactionDetails);
        } else {
          showDialog2();
        }
      } else {
        showDialog2();
      }
    }
    print("Response body:" + responseData.body);
  }

  void showDialog1(dynamic transactionDetails) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green,
            ),
            Text(
              "Payment Successfull",
              style: TextStyle(color: Colors.green),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Transaction Id :"),
                Container(
                    width: 130,
                    child: Text(
                      transactionDetails['transaction']['id'].toString(),
                      style: TextStyle(color: Colors.grey),
                    ))
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Status :"),
                Container(
                    width: 130,
                    child: Text(
                      transactionDetails['transaction']['status'].toString(),
                      style: TextStyle(color: Colors.grey),
                    ))
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Amount :"),
                Container(
                    width: 130,
                    child: Text(
                      transactionDetails['transaction']['amount'].toString() +
                          " " +
                          transactionDetails['transaction']['currencyIsoCode']
                              .toString(),
                      style: TextStyle(color: Colors.grey),
                    ))
              ],
            )
          ],
        ),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Okay"))
        ],
      ),
    );
  }

  void showDialog2() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.timesCircle,
              size: 80,
              color: Colors.red,
            ),
            SizedBox(height: 10),
            Text(
              "Payment Failed",
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Okay"))
        ],
      ),
    );
  }
}
