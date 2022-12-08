import 'dart:ui';

enum ResultType { neutral, info, success, error, warning }

extension ResultTypeExt on ResultType {
  Color get color {
    switch (this) {
      case ResultType.neutral:
        return const Color(0xFF303030);
      case ResultType.info:
        return const Color(0xFF1976D2);
      case ResultType.success:
        return const Color(0xFF689F38);
      case ResultType.error:
        return const Color(0xFFD32F2F);
      case ResultType.warning:
        return const Color(0xFFFFA000);
    }
  }
}
