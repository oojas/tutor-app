import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetials extends StatefulWidget {
  String name,
      description,
      age,
      email,
      exp,
      phoneno,
      subjects,
      uid,
      url,
      userid,
      curricullum,
      curricullumPdf,
      charge;
  dynamic transactionDetails;
  List<dynamic> enrolledStudents;
  GeoPoint point;
  CourseDetials(
      {this.age,
      this.charge,
      this.description,
      this.email,
      this.enrolledStudents,
      this.exp,
      this.name,
      this.phoneno,
      this.point,
      this.subjects,
      this.uid,
      this.transactionDetails,
      this.curricullum,
      this.curricullumPdf,
      this.userid,
      this.url});
  @override
  _CourseDetialsState createState() => _CourseDetialsState();
}

class _CourseDetialsState extends State<CourseDetials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Course Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(left: 5, top: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      widget.url,
                      width: MediaQuery.of(context).size.width / 2 - 55,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 10),
                      width: MediaQuery.of(context).size.width / 2 + 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width / 2 + 40,
                              child: Text(
                                widget.name,
                                style: TextStyle(fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              width: MediaQuery.of(context).size.width / 2 + 40,
                              child: Text(
                                widget.email,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              width: MediaQuery.of(context).size.width / 2 + 40,
                              child: Text(
                                widget.exp + " years of experience",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              width: MediaQuery.of(context).size.width / 2 + 40,
                              child: Text(
                                widget.subjects,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              )),
                          OutlineButton(
                            onPressed: () async {
                              final phoneCall =
                                  FlutterPhoneState.startPhoneCall(
                                      widget.phoneno);
                            },
                            borderSide: BorderSide(color: Colors.teal),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            child: Text("Call the teacher"),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 20,
                          color: Colors.teal,
                        ),
                        SizedBox(width: 2),
                        Text("Curricullum",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Cocogoose')),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child:
                        widget.curricullum == null || widget.curricullum == ""
                            ? Text(
                                "Lorem ipsum Lorem ispsum lorem ispsum lorem ipsum lorem ispsum ispsum lorem isisis osoididi  skdsdjsd kdfdfjdhf",
                              )
                            : Text(widget.curricullum),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 20,
                          color: Colors.teal,
                        ),
                        SizedBox(width: 2),
                        Text("Curricullum Pdf",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Cocogoose')),
                        IconButton(
                            icon: Icon(Icons.cloud_download),
                            onPressed: () async {
                              if (await canLaunch(widget.curricullumPdf)) {
                                launch(widget.curricullumPdf);
                              }
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Text(
                          "To download curricullum press ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Icon(
                          Icons.cloud_download,
                          color: Colors.grey,
                        ),
                        Text(
                          " button",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 20,
                          color: Colors.teal,
                        ),
                        SizedBox(width: 2),
                        Text("Rating",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Cocogoose')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('ratings')
                  .document(widget.uid)
                  .collection('ratings')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SpinKitCircle(
                    duration: Duration(seconds: 1),
                    color: Colors.teal,
                  );
                }
                if (snapshot.hasError) {
                  return SpinKitCircle(
                      duration: Duration(seconds: 1), color: Colors.teal);
                }
                print(snapshot.data.documents.length);
                List<dynamic> ratings = [];
                double totalrating = 0, avgrating = 0;
                double initialRatings = 0;
                if (snapshot.data.documents.length > 0) {
                  snapshot.data.documents.forEach((element) {
                    ratings.add(element.data['ratings']);
                    if (element.documentID == widget.userid) {
                      initialRatings = element['ratings'];
                    }
                  });

                  ratings.forEach((element) {
                    totalrating = totalrating + element;
                  });
                  if (ratings.length > 0) {
                    avgrating = totalrating / ratings.length;
                    Firestore.instance
                        .collection('Users')
                        .document(widget.uid)
                        .updateData({'rating': avgrating});
                  }
                }

                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(avgrating.toString() +
                            " (${ratings.length} reviews)"),
                      ),
                      SizedBox(height: 5),
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 20,
                              color: Colors.teal,
                            ),
                            SizedBox(width: 2),
                            Text("Rate Teacher",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontFamily: 'Cocogoose'))
                          ],
                        ),
                      ),
                      RatingBar(
                        initialRating: initialRatings,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          Firestore.instance
                              .collection('ratings')
                              .document(widget.uid)
                              .collection('ratings')
                              .document(widget.userid)
                              .setData({'ratings': rating});
                        },
                      )
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 20,
                    color: Colors.teal,
                  ),
                  SizedBox(width: 2),
                  Text("Transaction Details",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Cocogoose')),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transaction Id :",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          widget.transactionDetails['transaction']['id'],
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount :",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          widget.transactionDetails['transaction']['amount'],
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transaction Date :",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          DateTime.parse(
                                  widget.transactionDetails['transaction']
                                      ['createdAt'])
                              .toString(),
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payment Type :",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          widget.transactionDetails['transaction']
                                      ['paymentInstrumentType'] ==
                                  "paypal_account"
                              ? "Paypal Account"
                              : "Card",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payer Email :",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          widget.transactionDetails['transaction']['paypal']
                              ['payerEmail'],
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
