import 'package:tutorappnew/screens/home/alertSignout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tutorappnew/loading.dart';
import 'package:tutorappnew/models/user.dart';
import 'package:tutorappnew/screens/home/PopupmenuItems.dart';
import 'package:tutorappnew/screens/home/dashboard.dart';
import 'package:tutorappnew/screens/home/searchPage.dart';
import 'package:tutorappnew/screens/home/sidedrawer/profile.dart';
import 'package:tutorappnew/screens/home/sidedrawer/sidedrawer.dart';
import 'package:tutorappnew/services/auth.dart';
import 'package:tutorappnew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _authService = AuthService();
  String url = '', username = '';
  String dropdownValue = 'One';
  bool loading = false;
  String uid = '123';
  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    _authService.getCurrentUser().then((value) {
      setState(() {
        uid = value['1'];
        username = value['2'];
        url = value['3'];
        loading = false;
      });
    });
    getData();
  }

  Future getData() async {}

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    if (user != null) {
      return StreamBuilder<UserType>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserType data = snapshot.data;

            return loading == true
                ? Loading()
                : Scaffold(
                    // floatingActionButton:
                    //     FloatingActionButton(onPressed: () async {
                    //   // Navigator.of(context).push(MaterialPageRoute(
                    //   //   builder: (context) => PaymentScreen1(),
                    //   // ));
                    //   // SharedPreferences prefs =
                    //   //             await SharedPreferences.getInstance();
                    //   //         await prefs.setBool('seen', false);
                    // }),
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      elevation: 0,
                      title: Text(data.typeOfUser),
                      actions: [
                        data.typeOfUser == "Student"
                            ? IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  Firestore.instance
                                      .collection('Users')
                                      .document(user.uid)
                                      .get()
                                      .then(
                                    (value) {
                                      GeoPoint point =
                                          value.data['location']['geopoint'];
                                      showSearch(
                                        context: context,
                                        delegate: SearchPage(
                                          studentUid: uid,
                                          studentCordinates: LatLng(
                                              point.latitude, point.longitude),
                                        ),
                                      );
                                    },
                                  );
                                })
                            : Container(),
                        PopupMenuButton(
                          itemBuilder: (context) {
                            return PopUpMenuItems()
                                .popUpMenuItems
                                .map((e) => PopupMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList();
                          },
                          onSelected: (value) {
                            if (value == "My Profile") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage(
                                            uid: data.uid,
                                          )));
                            }
                            if (value == "Logout") {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertSignOut(),
                              );
                            }
                          },
                        )
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: DashBoard(
                        data: data,
                      ),
                    ),

                    drawer: SideDrawer(
                      data: data,
                      url: data.url,
                      username: username,
                    ),
                  );
          } else {
            return SpinKitFadingCircle(
              color: Colors.white,
              size: 50.0,
            );
          }
        },
      );
    } else {
      return SpinKitFadingCircle(
        color: Colors.white,
        size: 50.0,
      );
    }
  }
}
