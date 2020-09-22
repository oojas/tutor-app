import 'package:tutorappnew/models/subject.dart';
import 'package:tutorappnew/models/user.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tutorappnew/loading.dart';

class TeachDashBoard extends StatefulWidget {
  final UserType data;
  TeachDashBoard({this.data});
  @override
  _TeachDashBoardState createState() => _TeachDashBoardState(data: data);
}

class _TeachDashBoardState extends State<TeachDashBoard> {
  List<Student> student = [];
  List studentid = [];
  final UserType data;
  _TeachDashBoardState({this.data});
  bool loading = false;

  getdata() async {
    await Firestore.instance
        .collection('Users')
        .document(data.uid)
        .get()
        .then((value) {
      if (value.data['students'] != null) {
        setState(() {
          studentid = value.data['students'];
        });
      }
    });
    studentid.forEach((element) async {
      await getList(element);
    });

    setState(() {
      loading = false;
    });
  }

  getList(String uid) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .get()
        .then((value) {
      student.add(Student(
        name: value.data['name'],
        age: value.data['age'],
        email: value.data['email'],
        phoneno: value.data['phoneno'],
        uid: value.documentID,
        url: value.data['url'],
        point: value.data['location']['geopoint'],
      ));
    });
  }

  getFuture() async {
    return await Firestore.instance.collection('Users').getDocuments();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration mbox = BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            offset: Offset(2, 2),
            blurRadius: 2,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 5,
          ),
        ]);
    BoxDecoration mboxInvert = BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white.withOpacity(0.085),
        boxShadow: [
          BoxShadow(
              color: Colors.white,
              offset: Offset(2, 2),
              blurRadius: 2,
              spreadRadius: -3),
          BoxShadow(
            color: Colors.grey[300],
            offset: Offset(-2, -2),
            blurRadius: 2,
          ),
        ]);
    return loading
        ? Loading()
        : FutureBuilder(
            future: getFuture(),
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
                    child: Text(
                      "There are " + student.length.toString() + " Student",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: student.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: GestureDetector(
                              onTap: () {},
                              child: FadeInUp(
                                child: Container(
                                  decoration: mboxInvert,
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ListTile(
                                      title: Text(
                                        student[index].name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        student[index].email,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(student[index].url),
                                      ),
                                      onTap: () {},
                                      selected: true,
                                    ),
                                  ),
                                ),
                              )),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
  }
}
