class NetworkException implements Exception {
  const NetworkException([this.code, this.message]);

  final String? code;
  final String? message;

  @override
  String toString() => 'Network Exception $code: ${message ?? 'Error unknown'}';
}

class AuthException implements Exception {
  const AuthException([this.code, this.message]);

  final String? code;
  final String? message;

  @override
  String toString() => 'Network Exception $code: ${message ?? 'Error unknown'}';
}

class CacheException implements Exception {
  const CacheException([this.message]);

  final String? message;

  @override
  String toString() => 'Cache Exception: ${message ?? 'Error unknown'}';
}

class DeviceNetworkException implements Exception {
  const DeviceNetworkException();

  @override
  String toString() =>
      'No internet connection, please check your network and try again.';
}

class NHostServiceNotSetupException implements Exception {
  @override
  String toString() =>
      'NHostServiceNotSetupException: Must initialize before using this class.';
}
