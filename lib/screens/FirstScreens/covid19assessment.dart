import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tutorappnew/services/covidQuestionList.dart';

class Covid19Assessment extends StatefulWidget {
  String uid;
  Covid19Assessment(this.uid);
  @override
  _Covid19AssessmentState createState() => _Covid19AssessmentState();
}

class _Covid19AssessmentState extends State<Covid19Assessment> {
  bool isLoading = false;
  bool iscough = false;
  bool isFever = false;
  bool isdiffBreathing = false;
  bool islossSmell = false;
  bool isDiabetes = false,
      ishypertension = false,
      isLungDisease = false,
      isheartDisease = false,
      isTravelled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Self assessment",
                  style: TextStyle(fontFamily: "Cocogoose", fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                FadeInLeft(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10, top: 20, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "1. " + CovidQuestion().question1,
                          style: TextStyle(fontFamily: "Roboto"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Cough"),
                                Checkbox(
                                    value: iscough,
                                    onChanged: (value) {
                                      setState(() {
                                        iscough = value;
                                      });
                                    }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Fever"),
                                Checkbox(
                                    value: isFever,
                                    onChanged: (value) {
                                      setState(() {
                                        isFever = value;
                                      });
                                    }),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Difficulty in Breathing"),
                            Checkbox(
                                value: isdiffBreathing,
                                onChanged: (value) {
                                  setState(() {
                                    isdiffBreathing = value;
                                  });
                                }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Loss of senses of smell and taste"),
                            Checkbox(
                                value: islossSmell,
                                onChanged: (value) {
                                  setState(() {
                                    islossSmell = value;
                                  });
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                FadeInRight(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10, top: 20, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "2. " + CovidQuestion().question2,
                          style: TextStyle(fontFamily: "Roboto"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Diabetes"),
                                Checkbox(
                                    value: isDiabetes,
                                    onChanged: (value) {
                                      setState(() {
                                        isDiabetes = value;
                                      });
                                    }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Hypertension"),
                                Checkbox(
                                    value: ishypertension,
                                    onChanged: (value) {
                                      setState(() {
                                        ishypertension = value;
                                      });
                                    }),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Lung disease"),
                                Checkbox(
                                    value: isLungDisease,
                                    onChanged: (value) {
                                      setState(() {
                                        isLungDisease = value;
                                      });
                                    }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Heart Disease"),
                                Checkbox(
                                    value: isheartDisease,
                                    onChanged: (value) {
                                      setState(() {
                                        isheartDisease = value;
                                      });
                                    }),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                FadeInLeft(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10, top: 20, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            "3. " + CovidQuestion().question3,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: "Roboto"),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No"),
                            Switch(
                                value: isTravelled,
                                onChanged: (value) {
                                  setState(() {
                                    isTravelled = value;
                                  });
                                }),
                            Text("Yes")
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  child: GestureDetector(
                    onTap: () {
                      submitCovidAssessment();
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10),
                        color: Colors.teal,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: isLoading
                                ? SpinKitCircle(
                                    size: 20,
                                    color: Colors.white,
                                    duration: Duration(seconds: 1),
                                  )
                                : Text("Submit",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                          )),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitCovidAssessment() {
    setState(() {
      isLoading = true;
    });
    Firestore.instance
        .collection("covidAssessment")
        .document(widget.uid)
        .setData({
      'uid': widget.uid,
      '1': {
        'question': CovidQuestion().question1,
        'isCough': iscough,
        'isFever': isFever,
        'isDiffBreathing': isdiffBreathing,
        'islossSmell': islossSmell,
      },
      '2': {
        'question': CovidQuestion().question2,
        'isDiabetes': isDiabetes,
        'isHypertension': ishypertension,
        'isLungDisease': isLungDisease,
        'isHeartDisease': isheartDisease,
      },
      '3': {'question': CovidQuestion().question3, 'isTravelled': isTravelled}
    }).then((value) {
      Timer(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      });
    });
  }
}
