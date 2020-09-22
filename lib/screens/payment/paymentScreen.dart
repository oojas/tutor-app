import 'package:tutorappnew/models/subject.dart';
import 'package:tutorappnew/screens/payment/PayStack.dart';
import 'package:tutorappnew/screens/wrapper.dart';
import 'package:tutorappnew/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../main.dart';

class PaymentScreen extends StatefulWidget {
  Teacher teacher;
  PaymentScreen({this.teacher});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Razorpay razorpay;
  int amount, newclass;
  double classes;
  String uid = '';
  List stu = [];
  List teachers = [];
  @override
  void initState() {
    super.initState();
    getData();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlerPaymentFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  Future getData() async {
    await AuthService().getCurrentUser().then((value) {
      setState(() {
        uid = value['1'];
      });
    });
    await Firestore.instance
        .collection('Users')
        .document(widget.teacher.uid)
        .get()
        .then((value) {
      setState(() {
        if (value.data['students'] != null) {
          stu = value.data['students'];
        }
        print(stu);
      });
    });
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .get()
        .then((value) {
      setState(() {
        newclass = value.data['newclass'];
        classes = value.data['classes'];
        if (value.data['teachers'] != null) {
          teachers = value.data['teachers'];
        }
      });
    });
  }

  void _handlerPaymentSuccess(
      PaymentSuccessResponse paymentSuccessResponse) async {
    newclass = ++newclass;
    classes = ++classes;
    stu.add(uid);
    teachers.add(widget.teacher.uid);
    await Firestore.instance
        .collection('Users')
        .document(widget.teacher.uid)
        .updateData({
      'students': stu,
    });
    await Firestore.instance.collection('Users').document(uid).updateData({
      'classes': classes,
      'newclass': newclass,
      'teachers': teachers,
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Payment Successfully completed"),
      ),
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Wrapper()));
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
    amount = int.parse(widget.teacher.price) * 100;
    return Scaffold(
      appBar: AppBar(title: Text("Buy Course")),
      body: Column(
        children: [
          Container(child: Card()),
          Row(
            children: [
              RaisedButton(
                child: Text("Proceed to pay"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
