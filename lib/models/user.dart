class User {
  final String uid;
  User({this.uid});
}

class UserType {
  final String uid, typeOfUser, url;
  UserType({this.uid, this.typeOfUser, this.url});
}

class StudentData {
  final int newclass, completed, confirmed, classes;
  StudentData({this.classes, this.completed, this.confirmed, this.newclass});
}
