/// + Repository-level failure that contains a [message]

abstract class Failure {
  const Failure([this.message = 'Unexpected Error']);

  final String? message;

  @override
  List<String?> get props => <String?>[message];
}

// + Repository-level failures

class NetworkFailure extends Failure {
  const NetworkFailure([String? message = defaultMessage]) : super(message);
  static const String defaultMessage = 'Network Failure';
}

class ApiFailure extends Failure {
  const ApiFailure([String? message = defaultMessage]) : super(message);
  static const String defaultMessage = 'Network Failure';
}

class AuthFailure extends Failure {
  const AuthFailure([String? message = defaultMessage]) : super(message);
  static const String defaultMessage = 'Auth Failure';
}

class SaveFailure extends Failure {
  const SaveFailure([String? message = defaultMessage]) : super(message);
  static const String defaultMessage = 'Save Failure';
}

class RetrieveFailure extends Failure {
  const RetrieveFailure([String? message = defaultMessage]) : super(message);
  static const String defaultMessage = 'Retrieve Failure';
}

class AuthServiceFailure extends Failure {
  const AuthServiceFailure([String? message = defaultMessage]) : super(message);
  static const String defaultMessage = 'NHost Auth Service Failure';
}
