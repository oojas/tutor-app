import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:http/http.dart' as http;

class PaymentScreen1 extends StatefulWidget {
  @override
  _PaymentScreen1State createState() => _PaymentScreen1State();
}

class _PaymentScreen1State extends State<PaymentScreen1> {
  String tokenizationKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  void getToken() async {
    http.Response response =
        await http.get('https://forvm-286217.uc.r.appspot.com/checkouts/new');
    tokenizationKey = response.body;
    tokenizationKey = tokenizationKey.trim();
    print(tokenizationKey);
  }

  void showNonce(BraintreePaymentMethodNonce nonce) async {
    http.Response responseData = await http.post(
        'https://forvm-286217.uc.r.appspot.com/checkouts',
        body: {'amount': "10000", 'payment_method_nonce': nonce.nonce});
    print("Response body:" + responseData.body);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Braintree example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () async {
                print(tokenizationKey);
                var request = BraintreeDropInRequest(
                  tokenizationKey: "sandbox_24hcq386_zymjm6sr8d4hwb22",
                  collectDeviceData: true,
                  paypalRequest: BraintreePayPalRequest(
                    amount: '4.20',
                    displayName: 'Example company',
                  ),
                  cardEnabled: true,
                );
                BraintreeDropInResult result =
                    await BraintreeDropIn.start(request);
                if (result != null) {
                  showNonce(result.paymentMethodNonce);
                }
              },
              child: Text('LAUNCH NATIVE DROP-IN'),
            ),
            RaisedButton(
              onPressed: () async {
                final request = BraintreeCreditCardRequest(
                  cardNumber: '4111111111111111',
                  expirationMonth: '12',
                  expirationYear: '2021',
                );
                BraintreePaymentMethodNonce result =
                    await Braintree.tokenizeCreditCard(
                  "sandbox_24hcq386_zymjm6sr8d4hwb22",
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
              },
              child: Text('TOKENIZE CREDIT CARD'),
            ),
            RaisedButton(
              onPressed: () async {
                final request = BraintreePayPalRequest(
                  billingAgreementDescription:
                      'I hereby agree that flutter_braintree is great.',
                  displayName: 'Your Company',
                );
                BraintreePaymentMethodNonce result =
                    await Braintree.requestPaypalNonce(
                  "sandbox_24hcq386_zymjm6sr8d4hwb22",
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
              },
              child: Text('PAYPAL VAULT FLOW'),
            ),
            RaisedButton(
              onPressed: () async {
                final request = BraintreePayPalRequest(amount: '13.37');
                BraintreePaymentMethodNonce result =
                    await Braintree.requestPaypalNonce(
                  "sandbox_24hcq386_zymjm6sr8d4hwb22",
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
              },
              child: Text('PAYPAL CHECKOUT FLOW'),
            ),
          ],
        ),
      ),
    );
  }
}
