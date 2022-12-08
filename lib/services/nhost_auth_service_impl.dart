import 'package:nhost_sdk/nhost_sdk.dart';

import 'nhost_service.dart';

abstract class INhostAuthService {
  AuthClient get authClient => _authClient;
  final AuthClient _authClient = NHostService().client.auth;
}
