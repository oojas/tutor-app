import 'dart:async';
import 'dart:io';

import 'package:tutorappnew/models/subject.dart';
import 'package:tutorappnew/screens/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  Teacher teacher;
  String studentUid;
  String studentEmail;
  PaymentPage({this.teacher, this.studentUid, this.studentEmail});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

String backendUrl = '{YOUR_BACKEND_URL}';
// Set this to a public key that matches the secret key you supplied while creating the heroku instance
String paystackPublicKey = 'pk_test_fadba748c64fffe737829471f5fb904f58bd0580';
const String appName = 'Tutor App';

class _PaymentPageState extends State<PaymentPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  int _radioValue = 0;
  CheckoutMethod _method;
  bool _inProgress = false;
  String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;

  @override
  void initState() {
    PaystackPlugin.initialize(publicKey: paystackPublicKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(title: const Text("Checkout")),
      body: new Container(
        padding: const EdgeInsets.all(20.0),
        child: new Form(
          key: _formKey,
          child: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Theme(
                  data: Theme.of(context).copyWith(
                    accentColor: green,
                    primaryColorLight: Colors.white,
                    primaryColorDark: navyBlue,
                    textTheme: Theme.of(context).textTheme.copyWith(
                          bodyText2: TextStyle(
                            color: lightBlue,
                          ),
                        ),
                  ),
                  child: Builder(
                    builder: (context) {
                      return _inProgress
                          ? new Container(
                              alignment: Alignment.center,
                              height: 50.0,
                              child: Platform.isIOS
                                  ? new CupertinoActivityIndicator()
                                  : new CircularProgressIndicator(),
                            )
                          : new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Flexible(
                                      flex: 3,
                                      child: new DropdownButtonHideUnderline(
                                        child: new InputDecorator(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            isDense: true,
                                            hintText: 'Checkout method',
                                          ),
                                          isEmpty: _method == null,
                                          child: new DropdownButton<
                                              CheckoutMethod>(
                                            value: _method,
                                            isDense: true,
                                            onChanged: (CheckoutMethod value) {
                                              setState(() {
                                                _method = value;
                                              });
                                            },
                                            items: banks.map((String value) {
                                              return new DropdownMenuItem<
                                                  CheckoutMethod>(
                                                value:
                                                    _parseStringToMethod(value),
                                                child: new Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    _horizontalSizeBox,
                                    new Flexible(
                                      flex: 2,
                                      child: new Container(
                                        width: double.infinity,
                                        child: _getPlatformButton(
                                          'Checkout',
                                          () => _handleCheckout(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handleCheckout(BuildContext context) async {
    if (_method == null) {
      _showMessage('Select checkout method first');
      return;
    }

    if (_method != CheckoutMethod.card && _isLocal) {
      _showMessage('Select server initialization method at the top');
      return;
    }

    _formKey.currentState.save();
    double amountDouble = double.parse(widget.teacher.charge);
    double fraction = amountDouble - amountDouble.toInt();
    fraction = fraction * 100;
    print(fraction);
    amountDouble = amountDouble.toInt() * 100 + fraction;
    print(amountDouble);
    Charge charge = Charge()
      ..amount = amountDouble.toInt()
      // ..amount = 10000 // In base currency
      ..email = widget.studentEmail
      ..card = _getCardFromUI();

    if (!_isLocal) {
      var accessCode = await _fetchAccessCodeFrmServer(_getReference());
      charge.accessCode = accessCode;
    } else {
      charge.reference = _getReference();
    }

    try {
      CheckoutResponse response = await PaystackPlugin.checkout(
        context,
        method: _method,
        charge: charge,
        fullscreen: false,
        logo: MyLogo(),
      );
      if (response.status) {
        print('object');
        // Firestore.instance
        //     .collection('Users')
        //     .document(widget.teacher.uid)
        //     .setData({
        //   'paymentData': response.reference,
        // }, merge: true);
        print('object');
        setState(() => _inProgress = false);
        print(widget.teacher.uid);
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
          'charge': widget.teacher.charge
        });
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Wrapper(),
        //   ),
        // );
      }
    } catch (e) {
      setState(() => _inProgress = false);
      _showMessage("Check console for error");
      rethrow;
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );
  }

  Widget _getPlatformButton(String string, Function() function) {
    // is still in progress
    Widget widget;
    if (Platform.isIOS) {
      widget = new CupertinoButton(
        onPressed: function,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        color: CupertinoColors.activeGreen,
        child: new Text(
          string,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      widget = new RaisedButton(
        onPressed: function,
        color: Colors.teal,
        textColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
        child: new Text(
          string.toUpperCase(),
          style: const TextStyle(fontSize: 17.0),
        ),
      );
    }
    return widget;
  }

  Future<String> _fetchAccessCodeFrmServer(String reference) async {
    String url = '$backendUrl/new-access-code';
    String accessCode;
    try {
      print("Access code url = $url");
      http.Response response = await http.get(url);
      accessCode = response.body;
      print('Response for access code = $accessCode');
    } catch (e) {
      setState(() => _inProgress = false);
      _updateStatus(
          reference,
          'There was a problem getting a new access code form'
          ' the backend: $e');
    }

    return accessCode;
  }

  _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n\ Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
    ));
  }

  bool get _isLocal => _radioValue == 0;
}

var banks = ['Bank', 'Card'];

CheckoutMethod _parseStringToMethod(String string) {
  CheckoutMethod method = CheckoutMethod.selectable;
  switch (string) {
    case 'Bank':
      method = CheckoutMethod.bank;
      break;
    case 'Card':
      method = CheckoutMethod.card;
      break;
  }
  return method;
}

class MyLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Text(
        "TutorApp",
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

const Color green = const Color(0xFF3db76d);
const Color lightBlue = const Color(0xFF34a5db);
const Color navyBlue = const Color(0xFF031b33);
