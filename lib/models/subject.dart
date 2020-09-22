import 'package:cloud_firestore/cloud_firestore.dart';

class Subject {
  String name;
  String imagePath;
  Subject({this.name, this.imagePath});
}

class Teacher {
  final String name,
      description,
      photo,
      age,
      exp,
      email,
      phoneno,
      subjects,
      url,
      charge,
      curricullum,
      curricullumPdf,
      price,
      uid;
  List<dynamic> enrolledStudents = [];
  final GeoPoint point;
  Teacher(
      {this.description,
      this.name,
      this.age,
      this.email,
      this.exp,
      this.curricullum,
      this.phoneno,
      this.photo,
      this.subjects,
      this.url,
      this.uid,
      this.charge,
      this.curricullumPdf,
      this.point,
      this.enrolledStudents,
      this.price});
}

class Student {
  final String name, age, email, phoneno, uid, url;
  final GeoPoint point;

  Student(
      {this.name,
      this.age,
      this.email,
      this.phoneno,
      this.uid,
      this.url,
      this.point});
}
