import 'package:flutter/material.dart';
import 'package:nhost_sdk/nhost_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'services/nhost_service.dart';

Future<void> main() async {
  await _initServices();
  final SharedPreferences preferences = await SharedPreferences.getInstance();

  final NHostService nhostService = NHostService();
  final bool isSignedIn =
      preferences.getString(refreshTokenClientStorageKey)?.isNotEmpty ?? false;
  if (isSignedIn) {
    await nhostService.client.auth.signInWithStoredCredentials();
  }
  runApp(
    App(
      isSignedIn: isSignedIn,
    ),
  );
}

Future<void> _initServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  NHostService.init(backendUrl: 'https://pddqvilrtckbgagptjto.nhost.run');
}
