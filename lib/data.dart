import 'dart:async';

import 'package:dio/dio.dart';

class StudentData{
  final int id;
  final String? firstName;
  final String? lastName;
  final String? course;
  final int score;
  final String? createdAt;
  final String? updateAt;

  StudentData({required this.id, required this.firstName, required this.lastName, required this.course, required this.score, required this.createdAt, required this.updateAt});
  StudentData.formJson(Map<String,dynamic> json):id=json['id'],firstName=json['first_name'],lastName=json['last_name'],course=json['course'],score=json['score'],createdAt=json['createdAt'],updateAt=json['updateAt'];
 }
class MyHttpClient{
  static Dio dio=Dio(BaseOptions(
    baseUrl: 'http://expertdevelopers.ir/api/v1/',

  )
  );
}

Future<List<StudentData>> getStudents() async{
  final response=await MyHttpClient.dio.get('experts/student');

  print(response.data);
  final List<StudentData> students=[];
  if(response.data is List<dynamic>){
    (response.data as List<dynamic>).forEach((element){
      students.add(StudentData.formJson(element));
    });
  }
  
  // Sort students by id in descending order
  students.sort((a, b) => b.id.compareTo(a.id));
  print(students.toString());
  return students;
}