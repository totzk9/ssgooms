// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Event _$$_EventFromJson(Map<String, dynamic> json) => _$_Event(
      id: json['id'] as String,
      title: json['title'] as String,
      minuteRead: (json['minuteRead'] as num).toDouble(),
      body: json['body'] as String,
      passcode: json['passcode'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$_EventToJson(_$_Event instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'minuteRead': instance.minuteRead,
      'body': instance.body,
      'passcode': instance.passcode,
      'date': instance.date?.toIso8601String(),
    };
