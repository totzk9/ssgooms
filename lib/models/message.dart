
import 'package:admin_ssgooms/models/result_type.dart';

class Message {
  Message({this.type = ResultType.neutral, this.text});

  factory Message.empty() => Message(text: '');

  final ResultType type;
  final String? text;

  bool get isEmpty => text?.isEmpty ?? true;
  bool get isNotEmpty => !isEmpty;

  @override
  String toString() => 'Message(type: $type, text: $text)';
}
