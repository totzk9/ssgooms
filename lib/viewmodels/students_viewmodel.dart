import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

import '../models/student.dart';
import '../services/nhost_auth_service_impl.dart';
import '../services/nhost_graphql_service_impl.dart';
import '../services/nhost_service.dart';
import 'event_viewmodel.dart';
import 'view_model_template.dart';

class StudentsViewModel extends ViewModelTemplate
    with INhostGraphQLService, INhostAuthService {
  StudentsViewModel() {
    init();
  }

  final List<Student> _students = <Student>[];
  List<Student> get students => _students;

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  DateTime? get date => _date;
  DateTime? _date;

  bool hasError = false;

  void onDatePicked(DateTime date) {
    dobController.text = date.toDMMMYYYYFormat;
    _date = date;
    notifyListeners();
  }

  Future<void> init() async {
    startLoading();
    try {
      final Stream<QueryResult> studentList = await subscription(
        document: '''
            subscription GetStudents {
              students {
                firstname
                dob
                id
                lastname
                gender
                level
                email
              }        
            }
          ''',
      );
      studentList.listen((QueryResult<Object?> event) {
        if (event.data == null) {
          return;
        }
        _students.clear();
        _students.addAll(
          (event.data!['students'] as List<dynamic>)
              .map((dynamic e) => Student.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
    stopLoading();
  }

  Future<bool> addStudent() async {
    hasError = false;
    if (emailController.text.trim().isEmpty) {
      return false;
    }
    try {
      await authClient.signUp(
          email: emailController.text.trim(), password: 'pass1234');
      // final res = await NHostService().client.post(
      //   Uri(path: '/signup/email-password'),
      //   body: {
      //     'email': emailController.text.trim(),
      //     'password': 'pass1234',
      //   },
      // );

      final bool isSuccess = await mutation<bool>(
        document: '''
        mutation AddStudent(${r'$object'}: students_insert_input!) {
          insert_students_one(object: ${r'$object'}) {
            id
          }
        } 
        ''',
        variables: {
          'object': {
            'firstname': firstnameController.text.trim(),
            'lastname': lastnameController.text.trim(),
            'email': emailController.text.trim(),
            'gender': genderController.text.trim(),
            'level': levelController.text.trim(),
            'dob': _date?.toIso8601String(),
          },
        },
        decoder: (Map<String, dynamic>? data) {
          if (data == null) {
            return false;
          }
          return true;
        },
      );

      if (!isSuccess) {
        return false;
      }
      _date = null;
      firstnameController.clear();
      lastnameController.clear();
      emailController.clear();
      genderController.clear();
      levelController.clear();
      return true;
    } catch (e) {
      if (e.toString().contains('Email already in use')) {
        hasError = true;
        notifyListeners();
      }
      print(e);
    }
    return false;
  }
}
