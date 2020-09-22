import 'package:flutter/material.dart';
import 'package:tutorappnew/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key key}) : super(key: key);

  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final AuthService _authService = AuthService();
  final int _totalPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                _currentPage = page;
                setState(() {});
              },
              children: <Widget>[
                _buildPageContent(
                  isShowImageOnTop: false,
                  image: 'assets/teacher2.png',
                  body: 'Teacher',
                  color: Colors.white,
                ),
                _buildPageContent(
                  isShowImageOnTop: true,
                  image: 'assets/student.png',
                  body: 'Student',
                  color: Colors.white,
                ),
                _buildPageContent(
                  isShowImageOnTop: false,
                  image: 'assets/parents.png',
                  body: 'Parent',
                  color: Colors.white,
                )
              ],
            ),
            Positioned(
              bottom: 40,
              left: MediaQuery.of(context).size.width * .05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * .9,
                    child: Row(
                      children: [
                        Container(
                          child: Row(children: [
                            for (int i = 0; i < _totalPages; i++)
                              i == _currentPage
                                  ? _buildPageIndicator(true)
                                  : _buildPageIndicator(false)
                          ]),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(
      {String image, String body, Color color, isShowImageOnTop}) {
    return Container(
      decoration: BoxDecoration(color: color),
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: [
              SizedBox(height: 20),
              Text(
                body,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
              SizedBox(height: 20),
              Center(
                child: Image.asset(image),
              ),
              SizedBox(height: 50),
              OutlineButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('userType', body);
                  await _authService.signInWithGoogle(body, context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                highlightElevation: 0,
                borderSide: BorderSide(color: Colors.blue),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                          image: AssetImage("assets/google_logo.png"),
                          height: 35.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
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
        color: isCurrentPage ? Colors.black : Colors.grey[600],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
