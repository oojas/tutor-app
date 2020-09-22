import 'package:tutorappnew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class DatabaseService {
  //collection reference
  final CollectionReference collectionReference =
      Firestore.instance.collection('Users');
  final String uid;

  DatabaseService({this.uid});
  final geo = Geoflutterfire();
  GeoFirePoint mypoint;
  // mypoint =  geo.point(
  //                 latitude: selectedLatlng.latitude,
  //                 longitude: selectedLatlng.longitude);
  Future updateUserData(String userType, String username) async {
    mypoint = geo.point(latitude: 22.78546, longitude: 78.95632);
    userType == 'Student'
        ? await collectionReference.document(uid).setData({
            'userType': userType,
            'username': username,
            'newclass': 0,
            'completed': 0,
            'confirmed': 0,
            'classes': 0,
            'location': mypoint.data,
            'timestamp': DateTime.now()
          })
        : userType == "Teacher"
            ? await collectionReference.document(uid).setData({
                'userType': userType,
                'username': username,
                'name': '',
                'description': '',
                'age': '',
                'emailid': '',
                'phoneno': '',
                'subjects': '',
                'location': mypoint.data,
                'enrolledStudents': [],
                'rating': 0,
                'approved': 0,
                'timestamp': DateTime.now()
              })
            : await collectionReference.document(uid).setData({
                'userType': userType,
                'username': username,
                'name': '',
                'description': '',
                'age': '',
                'emailid': '',
                'phoneno': '',
                'subjects': '',
                'location': mypoint.data,
                'enrolledStudents': [],
                'approved': 0,
                'timestamp': DateTime.now()
              });
  }

//userData from snapshot
  UserType _userDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return UserType(
      uid: uid,
      typeOfUser: documentSnapshot.data['userType'],
      url: documentSnapshot.data['url'],
    );
  }

  // get user doc stream
  Stream<UserType> get userData {
    return collectionReference
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  Future<StudentData> getStudentData() async {
    return await collectionReference.document(uid).get().then((value) {
      return StudentData(
        classes: value.data['classes'],
        completed: value.data['completed'],
        confirmed: value.data['confirmed'],
        newclass: value.data['newclass'],
      );
    });
  }

  Future updateStudentData() async {
    return await collectionReference.document(uid).updateData({
      'newclass': 0,
      'classes': 0,
      'completed': 0,
      'confirmed': 0,
    });
  }

  Future checkTheUser(String userid, String usertype, String userName) async {
    collectionReference.document(userid).get().then((value) {
      if (value.exists) {
        if (value.data['userType'] == 'Student') {
          //updateStudentData();
        }
        return value;
      } else {
        return updateUserData(usertype, userName);
      }
    });
  }
}
