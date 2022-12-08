import 'package:flutter/material.dart';
import 'package:nhost_flutter_auth/nhost_flutter_auth.dart';

import 'routes/pages.dart';
import 'services/nhost_service.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.isSignedIn,
  });

  final bool isSignedIn;

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: const <SingleChildWidget>[],
    //   child: NhostAuthProvider(
    //       auth: nHostService.client.auth,
    //       child: const _MainApp(),
    //     ),
    // );
    return NhostAuthProvider(
      auth: NHostService().client.auth,
      child: _MainApp(
        isSignedIn: isSignedIn,
      ),
    );
  }
}

class _MainApp extends StatefulWidget {
  const _MainApp({
    super.key,
    required this.isSignedIn,
  });

  final bool isSignedIn;

  @override
  State<_MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<_MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      initialRoute: widget.isSignedIn ? Routes.home : Routes.auth,
      routes: Pages.routes,
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) {
            return _FallbackPage(settings.name ?? 'unknown');
          },
        );
      },
    );
  }
}

class _FallbackPage extends StatelessWidget {
  const _FallbackPage(this.routeName);

  final String routeName;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'page not found',
              textAlign: TextAlign.center,
              style: textTheme.headline5?.copyWith(
                color: colorScheme.primary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
