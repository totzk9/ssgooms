import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:graphql/client.dart';

import '../models/event.dart';
import '../services/nhost_graphql_service_impl.dart';
import 'view_model_template.dart';

class EventsViewModel extends ViewModelTemplate with INhostGraphQLService {
  EventsViewModel() {
    init();
  }

  final List<Event> _events = <Event>[];
  List<Event> get events => _events;

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

  Future<void> init() async {
    startLoading();
    try {
      final Stream<QueryResult> eventList = await subscription(
        document: '''
            subscription GetEvents {
              events(order_by: {date: asc}) {
                body
                date
                id
                minuteRead
                title
                passcode
              }        
            }
          ''',
      );
      eventList.listen((QueryResult<Object?> event) {
        if (event.data == null) {
          return;
        }
        _events.clear();
        _events.addAll(
          (event.data!['events'] as List<dynamic>)
              .map((dynamic e) => Event.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
    stopLoading();
  }

  Future<bool> addEvent() async {
    final bool isSuccess = await mutation<bool>(
      document: '''
        mutation AddEvent(${r'$object'}: events_insert_input!) {
          insert_events_one(object: ${r'$object'}) {
            id
          }
        }
        ''',
      variables: {
        'object': {
          'title': nameController.text.trim(),
          'body': descController.text.trim(),
          'minuteRead': 2,
          'passcode': passCodeController.text.trim(),
          'date': _date?.toIso8601String(),
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
    dateController.clear();
    nameController.clear();
    descController.clear();
    passCodeController.clear();
    return true;
  }
}

extension DateTimeExt on DateTime {
  String get toDMMMYYYYFormat => DateFormat('d MMM yyyy').format(this);
}
