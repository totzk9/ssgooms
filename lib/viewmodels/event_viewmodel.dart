import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';
import '../services/nhost_graphql_service_impl.dart';
import 'view_model_template.dart';

class EventViewModel extends ViewModelTemplate with INhostGraphQLService {
  EventViewModel({required this.event}) {
    nameController.text = event.title;
    descController.text = event.body;
    passCodeController.text = event.passcode ?? '';
    dateController.text = event.date?.toDMMMYYYYFormat ?? '';
    _date = event.date;
  }
  final Event event;

  /// this will notify listeners to update currentTime data for DateTimePicker

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController passCodeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  DateTime? get date => _date;
  DateTime? _date;

  void onDatePicked(DateTime date) {
    dateController.text = date.toDMMMYYYYFormat;
    _date = date;
    notifyListeners();
  }

  Future<bool> updateEvent() async {
    try {
      return await mutation<bool>(
        document: '''
          mutation UpdateEvent(${r'$id'}: uuid!, ${r'$body'}: String, ${r'$date'}: date, ${r'$title'}: String, ${r'$passcode'}: String) {
            update_events_by_pk(pk_columns: {id: ${r'$id'}}, _set: {body: ${r'$body'}, date: ${r'$date'}, title: ${r'$title'}, passcode: ${r'$passcode'}}) {
              body
              date
              id
              minuteRead
              title
              passcode
            }
          }
        ''',
        variables: <String, dynamic>{
          'id': event.id,
          'body': descController.text.trim(),
          'date': date?.toIso8601String(),
          'title': nameController.text.trim(),
          'passcode': passCodeController.text.trim(),
        },
        decoder: (Map<String, dynamic>? data) {
          if (data == null) {
            return false;
          }
          return true;
        },
      );
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> deleteEvent() async {
    try {
      return await mutation<bool>(
        document: '''
          mutation DeleteEvent(${r'$id'}: uuid!) {
            delete_events_by_pk(id: ${r'$id'}) {
              id
            }
          }
        ''',
        variables: <String, dynamic>{
          'id': event.id,
        },
        decoder: (Map<String, dynamic>? data) {
          if (data == null) {
            return false;
          }
          return true;
        },
      );
    } catch (e) {
      print(e);
    }

    _date = null;
    dateController.clear();
    nameController.clear();
    descController.clear();
    passCodeController.clear();
    return false;
  }
}

extension DateTimeExt on DateTime {
  String get toDMMMYYYYFormat => DateFormat('d MMM yyyy').format(this);
}
